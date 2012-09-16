package Protocol::EMIUCP::Session::Window;

=head1 SYNOPSIS

  my $sess = Protocol::EMIUCP::Session::Window->new(
      window => 10,
  );
  my $n = $sess->reserve_trn;
  $sess->free_trn($n);

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Session::TRN;
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

has '_trns' => (
    isa       => 'ArrayRef[Protocol::EMIUCP::Session::TRN]',
    is        => 'ro',
    default   => sub { [] },
);

has '_count_free_trns' => (
    isa       => 'Int',
    is        => 'rw',
    lazy      => 1,
    default   => sub { $_[0]->window },
);

sub trn {
    my ($self, $n) = @_;
    return $self->_trns->[$n];
};

sub reserve_trn {
    my ($self, $n) = @_;

    AE::log debug => 'reserve_trn %s', defined $n ? sprintf '%02d', $n : '';

    Protocol::EMIUCP::Exception->throw( message => 'No free TRN found' )
        unless $self->is_free_trn;

    if (defined $n) {
        Protocol::EMIUCP::Exception->throw( message => 'This TRN already exists' )
            if defined $self->_trns->[$n];
    }
    else {
        FIND: {
            for ($n=0; $n < 100; $n++) {
                if (not defined $self->_trns->[$n]) {
                    last FIND;
                };
            };
            Protocol::EMIUCP::Exception->throw( message => 'No free TRN found' );
        };
    };

    $self->_count_free_trns($self->_count_free_trns - 1);
    $self->_trns->[$n] = Protocol::EMIUCP::Session::TRN->new(
        $self->_build_args,
        on_timeout => sub {
            AE::log debug => 'reserve_trn on_timeout %02d', $n;
            $self->on_timeout->($self, $n) if $self->has_on_timeout;
            $self->free_trn($n);
        },
    );

    return $n;
};

sub free_trn {
    my ($self, $n) = @_;

    AE::log debug => 'free_trn %02d', $n;

    Protocol::EMIUCP::Exception->throw( message => 'No such TRN is reserved' )
        unless defined $self->_trns->[$n];

    $self->_trns->[$n]->free;
    undef $self->_trns->[$n];
    $self->_count_free_trns($self->_count_free_trns + 1);

    AE::log debug => 'free_trn return %02d', $n;

    return $n;
};

sub is_free_trn {
    my ($self) = @_;
    return $self->_count_free_trns > 0;
};

1;
