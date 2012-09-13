package Protocol::EMIUCP::Session;

=head1 SYNOPSIS

  my $sess = Protocol::EMIUCP::Session(
      login      => 4321,
      pwd        => 'secret',
      window     => 10,
      on_read    => sub { my ($sess, $msg) = @_; ... },
      on_write   => sub { my ($sess, $msg) = @_; ... },
      on_timeout => sub { my ($sess, $what, $msg) = @_; ... },
  );
  $sess->write_message($msg);

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Session::TRN;

with qw(Protocol::EMIUCP::OO::Role::BuildArgs);

use Protocol::EMIUCP::Message::Types;
use Mouse::Util::TypeConstraints;

has 'login' => (
    isa       => 'EMIUCP_Num16',
    is        => 'ro',
    predicate => 'has_login',
);

has 'pwd' => (
    isa       => 'Str',
    is        => 'ro',
    predicate => 'has_pwd',
);

has 'o60' => (
    does      => 'Protocol::EMIUCP::Message::Role',
    is        => 'ro',
    predicate => 'has_o60',
    lazy      => 1,
    default   => sub {
        Protocol::EMIUCP::Message->new(
            o        => 'O',
            ot       => 60,
            oadc     => $_[0]->login,
            oton     => OTON_ABBREVIATED,
            onpi     => ONPI_PRIVATE,
            styp     => STYP_ADD_ITEM_TO_MO_LIST,
            pwd_utf8 => $_[0]->pwd,
            vers     => '0100',
        )
    },
);

has 'on_read' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_read',
);

has 'on_write' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_write',
);

has 'on_timeout' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_timeout',
);

has '_trn_in' => (
    isa       => 'Protocol::EMIUCP::Session::TRN',
    is        => 'ro',
    default   => sub {
        my ($self) = @_;
        Protocol::EMIUCP::Session::TRN->new(
            $self->_build_args,
            on_timeout => sub { $self->_on_timeout_in(@_) },
        );
    },
);

has '_trn_out' => (
    isa       => 'Protocol::EMIUCP::Session::TRN',
    is        => 'ro',
    default   => sub {
        my ($self) = @_;
        Protocol::EMIUCP::Session::TRN->new(
            $self->_build_args,
            on_timeout => sub { $self->_on_timeout_out(@_) },
        );
    },
);

has '_msg_in' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

has '_msg_out' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

has '_cv_out' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

has '_cv_out_any' => (
    is        => 'rw',
);

sub open_session {
    my ($self) = @_;
    if ($self->has_o60 or $self->has_pwd) {
        my $msg_with_trn = $self->write_message($self->o60);
        $self->wait_for_trn($msg_with_trn->trn);
    };
};

sub write_message {
    my ($self, $msg) = @_;

    confess "$msg is not an EMI-UCP message"
        unless blessed $msg and $msg->does('Protocol::EMIUCP::Message::Role');

    if ($msg->o) {
        my $trn = $self->_trn_out->reserve;
        my $msg_with_trn = $msg->clone( trn => $trn );
        $self->_msg_out->[$trn] = $msg_with_trn;
        $self->_cv_out->[$trn] = AE::cv;
        $self->_cv_out_any(AE::cv) if not $self->_trn_out->is_free;
        $self->on_write->($self, $msg_with_trn) if $self->has_on_write;
        return $msg_with_trn;
    }
    else {
        $self->_trn_in->free($msg->trn);
        undef $self->_msg_in->[$msg->trn];
        $self->on_write->($self, $msg) if $self->has_on_write;
        return $msg;
    };
};

sub read_message {
    my ($self, $msg) = @_;

    if ($msg->r) {
        $self->_trn_out->free($msg->trn);
        undef $self->_msg_out->[$msg->trn];
        $self->_cv_out->[$msg->trn]->send;
        $self->_cv_out_any->send if $self->_cv_out_any;
    }
    else {
        $self->_trn_in->reserve($msg->trn);
        $self->_msg_in->[$msg->trn] = $msg;
    };

    $self->on_read->($self, $msg) if $self->has_on_read;

    return $msg;
};

sub wait_for_trn {
    my ($self, $trn) = @_;
    if ($self->_cv_out->[$trn]) {
        $self->_cv_out->[$trn]->recv;
        undef $self->_cv_out->[$trn];
    };
};

sub wait_for_all_trn {
    my ($self) = @_;
    for (my $trn = 0; $trn < $self->_trn_out->window; $trn++) {
        $self->wait_for_trn($trn);
    };
};

sub wait_for_any_trn {
    my ($self) = @_;
    $self->_cv_out_any->recv if $self->_cv_out_any;
};

sub _on_timeout_in {
    my ($self, $trn) = @_;
    my $msg = $self->_msg_in->[$trn];

    return $self->on_timeout->($self, read => $msg) if $self->has_on_timeout;

    my $rpl = $msg->new_response(
        nack => 1,
        ec   => EC_OPERATION_NOT_ALLOWED,
        sm   => ' Timeout for EMI-UCP operation',
    );
    $self->on_write->($rpl);
};

sub _on_timeout_out {
    my ($self, $trn) = @_;
    my $msg = $self->_msg_out->[$trn];

    return $self->on_timeout->($self, write => $msg) if $self->has_on_timeout;

    my $rpl = $msg->new_response(
        nack => 1,
        ec   => EC_OPERATION_NOT_ALLOWED,
        sm   => ' Timeout for EMI-UCP operation',
    );
    $self->on_read->($rpl);
};

1;
