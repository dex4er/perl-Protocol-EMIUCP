package Protocol::EMIUCP::Connection;

=head1 SYNOPSIS

  use AnyEvent::Socket;
  tcp_server 'localhost', 12345, sub {
      my ($fh) = @_;
      my $conn = Protocol::EMIUCP::Connection->new(
          fh     => $fh,
          window => 10,
          login  => 1234,
          pwd    => 'SECRET',
          on_message => sub { my $msg = shift; cb() },
      );
      $conn->write_message($msg);
  };

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Message::Types;

use Mouse::Util::TypeConstraints;

has 'fh' => (
    isa       => 'FileHandle',
    is        => 'ro',
    required  => 1,
);

has 'login' => (
    isa       => 'EMIUCP_Num16',
    is        => 'ro',
);

has 'pwd' => (
    isa       => 'Str',
    is        => 'ro',
);

has 'window' => (
    isa       => subtype( as 'Int', where { $_ > 0 && $_ <= 100 } ),
    is        => 'ro',
);

has 'o60' => (
    isa       => 'Protocom::EMIUCP::Message',
    is        => 'ro',
    lazy      => 1,
    default   => sub { Protocol::EMIUCP::Message->new(
        o_r      => 'O',
        ot       => 60,
        oadc     => $_[0]->login,
        oton     => OTON_ABBREVIATED,
        onpi     => ONPI_PRIVATE,
        styp     => STYP_ADD_ITEM_TO_MO_LIST,
        pwd_utf8 => $_[0]->pwd,
        vers     => '0100',
    ) },
);

has 'on_message' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_message',
);

has '_hdl' => (
    isa       => 'AnyEvent::Handle',
    is        => 'ro',
    builder   => '_build_hdl',
);

use AnyEvent;
use AnyEvent::Handle;

sub _build_hdl {
    my ($self) = @_;

    return AnyEvent::Handle->new(
        fh       => $self->fh,
        on_error => sub {
            my ($hdl, $fatal, $msg) = @_;
            AE::log error => $msg;
            $hdl->destroy;
        },
        on_read  => sub {
            $self->_hdl->push_read(regex => qr/ .*? \x02 (.*?) \x03 /xs, sub {
                my ($hdl, $data) = @_;

                my $str = $1;
                AE::log info => "<<< [%s]", $str;
                my $msg = eval { Protocol::EMIUCP::Message->new_from_string($str) };
                $self->on_message->($msg) if $msg and $self->has_on_message;
                my $rpl = do {
                    if (my $e = $@) {
                        # Cannot parse EMI-UCP message
                        AE::log error => "$e";
                        my $sm = $e->error;
                        Protocol::EMIUCP::Message->new(
                            trn  => $e->trn,
                            ot   => $e->ot,
                            o_r  => 'R',
                            nack => 1,
                            ec   => EC_SYNTAX_ERROR,
                            sm   => sprintf ' %s: %s', $e->message, $e->error,
                        ) if (($e->o_r||'') eq 'O');
                    }
                    elsif ($msg and $msg->o_r eq 'O') {
                        # Reply only for Operation
                        if ($msg->ot =~ /^(01|51|60)$/) {
                            # OT allowed by SMSC
                            my %sm = do {
                                if ($msg->ot =~ /^(01|51)$/) {
                                    my @t = localtime;
                                    $t[5] %= 100;
                                    +(sm => $msg->oadc . ':' . sprintf '%02d%02d%02d%02d%02d%02d', @t[3,4,5,2,1,0]);
                                }
                                else {
                                    +();
                                };
                            };
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, o_r => 'R', ack => 1, %sm);
                        }
                        else {
                            # Not allowed by SMSC
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, o_r => 'R', nack => 1, ec => EC_OPERATION_NOT_ALLOWED);
                        };
                    };
                };
                $self->write_message($rpl) if $rpl;
            });
        },
        on_eof   => sub {
            $self->_hdl->destroy;
        },
    );
};

sub BUILD {
    my ($self) = @_;

    $self->_hdl->push_write(sprintf "\x02%s\x03", $self->o60->as_string) if $self->login;
};

sub write_message {
    my ($self, $msg) = @_;

    confess "$msg is not an EMI-UCP message"
        unless blessed $msg and $msg->does('Protocol::EMIUCP::Message::Role');

    AE::log info => ">>> [%s]", $msg->as_string;

    $self->_hdl->push_write(sprintf "\x02%s\x03", $msg->as_string) if $msg;
};

1;
