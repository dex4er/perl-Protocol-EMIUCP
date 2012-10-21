package Protocol::EMIUCP::Session::Window;

=head1 SYNOPSIS

  my $sess = Protocol::EMIUCP::Session::Window->new(
      window => 10,
  );
  my $trn = $sess->reserve_slot;
  $sess->free_slot($trn);

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Session::Slot;
use Protocol::EMIUCP::Session::Slot::Exception;

with qw(Protocol::EMIUCP::OO::Role::BuildArgs);

use AnyEvent;

use Mouse::Util::TypeConstraints;

has 'window' => (
    isa       => subtype( as 'Int', where { $_ > 0 && $_ <= 100 } ),
    is        => 'ro',
    default   => 1,
);

has 'on_timeout' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_timeout',
);

has '_slots' => (
    isa       => 'ArrayRef[Protocol::EMIUCP::Session::Slot]',
    is        => 'ro',
    clearer   => '_clear_slots',
    default   => sub { [] },
);

has 'count_free_slots' => (
    isa       => 'Int',
    is        => 'ro',
    writer    => '_set_count_free_slots',
    lazy      => 1,
    default   => sub { $_[0]->window },
);

has '_cv_free_any_slot' => (
    is        => 'rw',
    predicate => '_has_cv_free_any_slot',
    clearer   => '_clear_cv_free_any_slot',
);

has '_cv_free_all_slots' => (
    is        => 'rw',
    predicate => '_has_cv_free_all_slots',
    clearer   => '_clear_cv_free_all_slots',
);

sub slot {
    my ($self, $trn) = @_;
    return $self->_slots->[$trn];
};

sub reserve_slot {
    my ($self, $trn) = @_;

    AE::log trace => 'reserve_slot %s', defined $trn ? sprintf '%02d', $trn : '';

    Protocol::EMIUCP::Session::Slot::Exception->throw(
        message => 'No free slot found',
    ) unless $self->has_free_slot;

    if (defined $trn) {
        Protocol::EMIUCP::Session::Slot::Exception->throw(
            message => 'This slot is already reserved',
            trn     => $trn,
        ) if defined $self->_slots->[$trn];
    }
    else {
        FIND: {
            my $slots = $self->_slots;
            for ($trn=0; $trn < 100; $trn++) {
                if (not defined $slots->[$trn]) {
                    last FIND;
                };
            };
            Protocol::EMIUCP::Session::Slot::Exception->throw(
                message => 'No free slot found',
            );
        };
    };

    $self->_set_count_free_slots($self->count_free_slots - 1);

    AE::log trace => 'count_free_slots %d', $self->count_free_slots;
    $self->_cv_free_any_slot(AE::cv) if $self->count_free_slots == 0;
    $self->_cv_free_all_slots(AE::cv) if $self->count_free_slots == $self->window - 1;

    $self->_slots->[$trn] = Protocol::EMIUCP::Session::Slot->new(
        $self->_build_args,
        on_timeout => sub {
            AE::log trace => 'reserve_slot on_timeout %02d', $trn;
            $self->on_timeout->($self, $trn) if $self->has_on_timeout;
            $self->free_slot($trn);
        },
    );

    return $trn;
};

sub free_slot {
    my ($self, $trn) = @_;

    AE::log trace => 'free_slot %02d', $trn;

    Protocol::EMIUCP::Session::Slot::Exception->throw(
        message => 'No such slot is reserved',
        trn     => $trn,
    ) unless defined $self->_slots->[$trn];

    $self->_slots->[$trn]->DISPOSE;
    undef $self->_slots->[$trn];
    $self->_set_count_free_slots($self->count_free_slots + 1);

    AE::log trace => 'count_free_slots %d', $self->count_free_slots;
    if ($self->count_free_slots == 1) {
        $self->_cv_free_any_slot->send;
    };
    if ($self->count_free_slots == $self->window) {
        $self->_cv_free_all_slots->send;
    };

    AE::log trace => 'free_slot end %02d', $trn;

    return $trn;
};

sub has_free_slot {
    my ($self) = @_;
    return $self->count_free_slots > 0;
};

sub has_reserved_slot {
    my ($self) = @_;
    return $self->count_free_slots < $self->window;
};

sub wait_for_free_slot {
    my ($self, $trn) = @_;
    $self->slot($trn)->wait_for_free if $self->slot($trn);
};

sub wait_for_any_free_slot {
    my ($self) = @_;
    AE::log trace => 'wait_for_any_free_slot';
    AE::log trace => '_has_cv_free_any_slot' if $self->_has_cv_free_any_slot;
    $self->_cv_free_any_slot->recv if $self->_has_cv_free_any_slot;
};

sub wait_for_all_free_slots {
    my ($self) = @_;
    AE::log trace => 'wait_for_all_free_slots';
    AE::log trace => '_has_cv_free_all_slots' if $self->_has_cv_free_all_slots;
    $self->_cv_free_all_slots->recv if $self->_has_cv_free_all_slots;
};

sub DISPOSE {
    my ($self) = @_;
    $self->_clear_slots;
};

sub DEMOLISH {
    my ($self) = @_;
    AE::log trace => 'DEMOLISH';
    warn "DEMOLISH $self" if defined ${^GLOBAL_PHASE} and ${^GLOBAL_PHASE} eq 'DESTRUCT';
};

1;
