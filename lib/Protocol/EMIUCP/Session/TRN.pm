package Protocol::EMIUCP::Session::TRN;

=head1 SYNOPSIS

  my $sess = Protocol::EMIUCP::Session::TRN->new(
      window   => 10,
  );
  my $trn = $sess->reserve;
  $sess->free($trn);

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Exception;

use AnyEvent;

use Mouse::Util::TypeConstraints;

has 'window' => (
    isa       => subtype( as 'Int', where { $_ > 0 && $_ <= 100 } ),
    is        => 'ro',
    default   => 1,
);

has 'timeout' => (
    isa       => subtype( as 'Num', where { $_ > 0 } ),
    is        => 'ro',
    default   => 15,
);

has 'on_timeout' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_timeout',
);

has '_slots' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

has '_count_free_slots' => (
    isa       => 'Int',
    is        => 'ro',
    writer    => '_set_count_free_slots',
    lazy      => 1,
    default   => sub { $_[0]->window },
);

sub reserve {
    my ($self, $trn) = @_;

    AE::log debug => 'reserve %s', $trn;

    Protocol::EMIUCP::Exception->throw( message => 'No free TRN found' )
        unless $self->is_free;

    if (defined $trn) {
        Protocol::EMIUCP::Exception->throw( message => 'This TRN already exists' )
            if defined $self->_slots->[$trn];
    }
    else {
        FIND: {
            for ($trn=0; $trn < 100; $trn++) {
                if (not defined $self->_slots->[$trn]) {
                    last FIND;
                };
            };
            Protocol::EMIUCP::Exception->throw( message => 'No free TRN found' );
        };
    };

    $self->_set_count_free_slots($self->_count_free_slots-1);
    $self->_slots->[$trn] = AE::timer $self->timeout, 0, sub {
        $self->free($trn);
        $self->on_timeout->($trn) if $self->has_on_timeout;
    };

    return $trn;
};

sub free {
    my ($self, $trn) = @_;

    AE::log debug => 'free %s', $trn;

    Protocol::EMIUCP::Exception->throw( message => 'No such TRN is reserved' )
        unless defined $self->_slots->[$trn];

    undef $self->_slots->[$trn];
    $self->_set_count_free_slots($self->_count_free_slots+1);

    return $trn;
};

sub is_free {
    my ($self) = @_;
    return $self->_count_free_slots > 0;
};

1;
