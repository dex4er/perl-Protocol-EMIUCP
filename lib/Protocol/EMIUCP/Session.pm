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
use Protocol::EMIUCP::Session::Window;

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

has '_window_in' => (
    isa       => 'Protocol::EMIUCP::Session::Window',
    is        => 'ro',
    default   => sub {
        my ($self) = @_;
        Protocol::EMIUCP::Session::Window->new(
            $self->_build_args,
            on_timeout => sub {
                my ($window, $trn) = @_;
                $self->_on_timeout_in($trn);
            },
        );
    },
);

has '_window_out' => (
    isa       => 'Protocol::EMIUCP::Session::Window',
    is        => 'ro',
    default   => sub {
        my ($self) = @_;
        Protocol::EMIUCP::Session::Window->new(
            $self->_build_args,
            on_timeout => sub {
                my ($window, $trn) = @_;
                $self->_on_timeout_out($trn);
            },
        );
    },
);

has '_cv_out_any' => (
    is        => 'rw',
);

sub open_session {
    my ($self) = @_;
    if ($self->has_o60 or $self->has_pwd) {
        my $msg_with_msg = $self->write_message($self->o60);
        $self->wait_for_free_slot($msg_with_msg->trn);
    };
};

sub write_message {
    my ($self, $msg) = @_;

    # TODO exception
    confess "$msg is not an EMI-UCP message"
        unless blessed $msg and $msg->does('Protocol::EMIUCP::Message::Role');

    AE::log debug => 'write_message %s', $msg->as_string;

    if ($msg->o) {
        my $trn = $self->_window_out->reserve_slot;
        my $msg_with_trn = $msg->clone( trn => $trn );
        $self->_window_out->slot($trn)->message($msg_with_trn);
        $self->_cv_out_any(AE::cv) if not $self->_window_out->is_free_slot;
        $self->on_write->($self, $msg_with_trn) if $self->has_on_write;
        return $msg_with_trn;
    }
    else {
        $self->_window_in->free_slot($msg->trn);
        $self->on_write->($self, $msg) if $self->has_on_write;
        return $msg;
    };
};

sub read_message {
    my ($self, $msg) = @_;

    # TODO exception
    confess "$msg is not an EMI-UCP message"
        unless blessed $msg and $msg->does('Protocol::EMIUCP::Message::Role');

    AE::log debug => 'read_message %s', $msg->as_string;

    if ($msg->r) {
        $self->on_read->($self, $msg) if $self->has_on_read;
        $self->_window_out->free_slot($msg->trn);
        $self->_cv_out_any->send if $self->_cv_out_any;
    }
    else {
        $self->_window_in->reserve_slot($msg->trn);
        $self->_window_in->slot($msg->trn)->message($msg);
        $self->on_read->($self, $msg) if $self->has_on_read;
    };

    return $msg;
};

sub wait_for_free_slot {
    my ($self, $trn) = @_;
    $self->_window_out->slot($trn)->wait_for_free
        if $self->_window_out->slot($trn);
};

sub wait_for_all_free_slots {
    my ($self) = @_;
    for (my $trn = 0; $trn < $self->_window_out->window; $trn++) {
        $self->wait_for_free_slot($trn);
    };
};

sub wait_for_any_free_slot {
    my ($self) = @_;
    $self->_cv_out_any->recv if $self->_cv_out_any;
};

sub _on_timeout_in {
    my ($self, $trn) = @_;

    AE::log debug => '_on_timeout_in %02d', $trn;

    my $msg = $self->_window_in->slot($trn)->message;

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

    AE::log debug => '_on_timeout_out %02d', $trn;

    my $msg = $self->_window_out->slot($trn)->message;

    return $self->on_timeout->($self, write => $msg) if $self->has_on_timeout;

    my $rpl = $msg->new_response(
        nack => 1,
        ec   => EC_OPERATION_NOT_ALLOWED,
        sm   => ' Timeout for EMI-UCP operation',
    );
    $self->on_read->($rpl);
};

1;
