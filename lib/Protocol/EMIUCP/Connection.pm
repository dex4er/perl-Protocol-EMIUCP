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
use Protocol::EMIUCP::Session;

with qw(Protocol::EMIUCP::OO::Role::BuildArgs);

use Protocol::EMIUCP::Message::Types;
use Mouse::Util::TypeConstraints;

has 'fh' => (
    isa       => 'FileHandle',
    is        => 'ro',
    required  => 1,
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

has '_sess' => (
    isa       => 'Protocol::EMIUCP::Session',
    is        => 'ro',
    builder   => '_build_sess',
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
                if ($msg) {
                    $self->_sess->read_message($msg);
                    $self->on_message->($self, $msg) if $self->has_on_message;
                }
                else {
                    my $e = $@;
                    if ($e and $e->o) {
                        # Cannot parse EMI-UCP message
                        AE::log error => "$e";
                        my $rpl = Protocol::EMIUCP::Message->new(
                            trn  => $e->trn,
                            ot   => $e->ot,
                            r    => 'R',
                            nack => 'N',
                            ec   => EC_SYNTAX_ERROR,
                            sm   => sprintf ' %s: %s', $e->message, $e->error,
                        );
                        $self->write_message($rpl);
                    };
                };
            });
        },
        on_eof   => sub {
            $self->_hdl->destroy;
        },
    );
};

sub _build_sess {
    my ($self) = @_;

    return Protocol::EMIUCP::Session->new(
        $self->_build_args,
        on_write => sub {
            my ($sess, $msg) = @_;
            AE::log info => ">>> [%s]", $msg->as_string;
            $self->_hdl->push_write(sprintf "\x02%s\x03", $msg->as_string) if $msg;
        },
        on_timeout => sub {
            my ($sess, $what, $msg) = @_;
            AE::log info => "??? [%s]", $msg->as_string;
        },
    );
};

sub write_message {
    my ($self, $msg) = @_;
    $self->_sess->write_message($msg);
};

sub open_session {
    my ($self, $msg) = @_;
    $self->_sess->open_session;
};

sub wait_for_trn {
    my ($self, $trn) = @_;
    $self->_sess->wait_for_trn($trn);
};

sub wait_for_all_trn {
    my ($self) = @_;
    $self->_sess->wait_for_all_trn;
};

sub wait_for_any_trn {
    my ($self) = @_;
    $self->_sess->wait_for_any_trn;
};

1;
