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
use Protocol::EMIUCP::Session::Exception;

with qw(Protocol::EMIUCP::OO::Role::BuildArgs);

use AnyEvent;
use Scalar::Util qw(weaken);

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
    clearer   => '_clear_window_in',
    default   => sub {
        my ($self) = @_;
        weaken $self;
        Protocol::EMIUCP::Session::Window->new(
            $self->_build_args,
            on_timeout => sub {
                my ($window, $trn) = @_;
                $self->_on_timeout_in($trn);
            },
        );
    },
    handles   => {
        wait_for_free_in_slot      => 'wait_for_free_slot',
        wait_for_any_free_in_slot  => 'wait_for_any_free_slot',
        wait_for_all_free_in_slots => 'wait_for_all_free_slots',
    },
);

has '_window_out' => (
    isa       => 'Protocol::EMIUCP::Session::Window',
    is        => 'ro',
    clearer   => '_clear_window_out',
    default   => sub {
        my ($self) = @_;
        weaken $self;
        Protocol::EMIUCP::Session::Window->new(
            $self->_build_args,
            on_timeout => sub {
                my ($window, $trn) = @_;
                $self->_on_timeout_out($trn);
            },
        );
    },
    handles   => {
        wait_for_free_out_slot      => 'wait_for_free_slot',
        wait_for_any_free_out_slot  => 'wait_for_any_free_slot',
        wait_for_all_free_out_slots => 'wait_for_all_free_slots',
    },
);

sub login_session {
    my ($self) = @_;
    if ($self->has_o60 or $self->has_pwd) {
        my $msg_with_trn = $self->write_message($self->o60);
        $self->wait_for_free_out_slot($msg_with_trn->trn);
    };
};

sub write_message {
    my ($self, $msg) = @_;

    Protocol::EMIUCP::OO::Argument::Exception->throw(
        message => "Not an EMI-UCP message",
        argument => $msg,
    ) unless blessed $msg and $msg->does('Protocol::EMIUCP::Message::Role');

    AE::log trace => 'write_message %s', $msg->as_string;

    if ($msg->o) {
        Protocol::EMIUCP::Session::Exception->throw(
            message => 'The operation does not support windowing',
            emiucp_string => $msg->as_string,
        ) if $self->_window_out->has_reserved_slot and not ($msg->ot >= 51 and $msg->ot <= 59);
        my $trn = $self->_window_out->reserve_slot;
        my $msg_with_trn = $msg->clone( trn => $trn );
        $self->_window_out->slot($trn)->message($msg_with_trn);
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

    Protocol::EMIUCP::OO::Argument::Exception->throw(
        message => "Not an EMI-UCP message",
        argument => $msg,
    ) unless blessed $msg and $msg->does('Protocol::EMIUCP::Message::Role');

    AE::log trace => 'read_message %s', $msg->as_string;

    if ($msg->r) {
        $self->on_read->($self, $msg) if $self->has_on_read;
        $self->_window_out->free_slot($msg->trn);
    }
    else {
        Protocol::EMIUCP::Message::Exception->throw(
            message => 'The operation does not support windowing',
            emiucp_string => $msg->as_string,
        ) if $self->_window_in->has_reserved_slot and not ($msg->ot >= 51 and $msg->ot <= 59);
        $self->_window_in->reserve_slot($msg->trn);
        $self->_window_in->slot($msg->trn)->message($msg);
        $self->on_read->($self, $msg) if $self->has_on_read;
    };

    return $msg;
};

sub _on_timeout_in {
    my ($self, $trn) = @_;

    AE::log trace => '_on_timeout_in %02d', $trn;

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

    AE::log trace => '_on_timeout_out %02d', $trn;

    my $msg = $self->_window_out->slot($trn)->message;

    return $self->on_timeout->($self, write => $msg) if $self->has_on_timeout;

    my $rpl = $msg->new_response(
        nack => 1,
        ec   => EC_OPERATION_NOT_ALLOWED,
        sm   => ' Timeout for EMI-UCP operation',
    );
    $self->on_read->($rpl);
};

sub wait_for_all_free_slots {
    my ($self) = @_;

    AE::log info => 'waiting for all free slots';

    $self->wait_for_all_free_out_slots;
    $self->wait_for_all_free_in_slots;
};

sub wait {
    my ($self, $time) = @_;

    AE::log info => 'waiting for %d second%s', $time, $time > 1 ? 's' : '';

    my $cv = AE::cv;
    my $timer = AE::timer $time, 0, sub {
        $cv->send;
    };
    $cv->recv;
};

sub free {
    my ($self) = @_;
    $self->_window_in->free;
    $self->_clear_window_in;
    $self->_window_out->free;
    $self->_clear_window_out;
};

sub DEMOLISH {
    my ($self) = @_;
    AE::log trace => 'DEMOLISH';
    warn "DEMOLISH $self" if defined ${^GLOBAL_PHASE} and ${^GLOBAL_PHASE} eq 'DESTRUCT';
};

1;
