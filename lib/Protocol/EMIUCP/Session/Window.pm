package Protocol::EMIUCP::Session::Window;

=head1 SYNOPSIS

  my $sess = Protocol::EMIUCP::Session::Window->new(
      window => 10,
  );
  my $trn = $sess->reserve_trn;
  $sess->free_trn($trn);

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

has '_trns' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

has '_count_free_trns' => (
    isa       => 'Int',
    is        => 'ro',
    writer    => '_set_count_free_trns',
    lazy      => 1,
    default   => sub { $_[0]->window },
);

sub reserve_trn {
    my ($self, $trn) = @_;

    AE::log debug => 'reserve_trn(%s)', $trn;

    Protocol::EMIUCP::Exception->throw( message => 'No free TRN found' )
        unless $self->is_free_trn;

    if (defined $trn) {
        Protocol::EMIUCP::Exception->throw( message => 'This TRN already exists' )
            if defined $self->_trns->[$trn];
    }
    else {
        FIND: {
            for ($trn=0; $trn < 100; $trn++) {
                if (not defined $self->_trns->[$trn]) {
                    last FIND;
                };
            };
            Protocol::EMIUCP::Exception->throw( message => 'No free TRN found' );
        };
    };

    $self->_set_count_free_trns($self->_count_free_trns-1);
    $self->_trns->[$trn] = AE::timer $self->timeout, 0, sub {
        $self->free_trn($trn);
        $self->on_timeout->($trn) if $self->has_on_timeout;
    };

    return $trn;
};

sub free_trn {
    my ($self, $trn) = @_;

    AE::log debug => 'free_trn(%s)', $trn;

    Protocol::EMIUCP::Exception->throw( message => 'No such TRN is reserved' )
        unless defined $self->_trns->[$trn];

    undef $self->_trns->[$trn];
    $self->_set_count_free_trns($self->_count_free_trns+1);

    return $trn;
};

sub is_free_trn {
    my ($self) = @_;
    return $self->_count_free_trns > 0;
};

1;
