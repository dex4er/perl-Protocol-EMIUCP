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
use Protocol::EMIUCP::Exception;

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
    default   => sub { [] },
);

has '_count_free_slots' => (
    isa       => 'Int',
    is        => 'rw',
    lazy      => 1,
    default   => sub { $_[0]->window },
);

sub slot {
    my ($self, $trn) = @_;
    return $self->_slots->[$trn];
};

sub reserve_slot {
    my ($self, $trn) = @_;

    AE::log debug => 'reserve_slot %s', defined $trn ? sprintf '%02d', $trn : '';

    Protocol::EMIUCP::Exception->throw( message => 'No free slot found' )
        unless $self->is_free_slot;

    if (defined $trn) {
        Protocol::EMIUCP::Exception->throw( message => 'This slot is already reserved' )
            if defined $self->_slots->[$trn];
    }
    else {
        FIND: {
            for ($trn=0; $trn < 100; $trn++) {
                if (not defined $self->_slots->[$trn]) {
                    last FIND;
                };
            };
            Protocol::EMIUCP::Exception->throw( message => 'No free slot found' );
        };
    };

    $self->_count_free_slots($self->_count_free_slots - 1);
    $self->_slots->[$trn] = Protocol::EMIUCP::Session::Slot->new(
        $self->_build_args,
        on_timeout => sub {
            AE::log debug => 'reserve_slot on_timeout %02d', $trn;
            $self->on_timeout->($self, $trn) if $self->has_on_timeout;
            $self->free_slot($trn);
        },
    );

    return $trn;
};

sub free_slot {
    my ($self, $trn) = @_;

    AE::log debug => 'free_slot %02d', $trn;

    Protocol::EMIUCP::Exception->throw( message => 'No such slot is reserved' )
        unless defined $self->_slots->[$trn];

    $self->_slots->[$trn]->free;
    undef $self->_slots->[$trn];
    $self->_count_free_slots($self->_count_free_slots + 1);

    AE::log debug => 'free_slot return %02d', $trn;

    return $trn;
};

sub is_free_slot {
    my ($self) = @_;
    return $self->_count_free_slots > 0;
};

1;
