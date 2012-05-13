package Protocol::EMIUCP::Exception;

use Mouse;
use MouseX::AttributeHelpers;

use overload '""' => 'as_string', fallback => 1;

has message => (isa => 'Str', is => 'ro', predicate => 'has_message');
has error   => (isa => 'Any', is => 'ro', predicate => 'has_error');

has _string_attributes => (
    metaclass => 'Collection::Array',
    isa => 'ArrayRef[Str]',
    is => 'ro',
    default => sub { [qw( message error )] },
    provides => {
        elements => 'string_attributes',
    },
);

sub throw {
    my ($self, @args) = @_;
    $self = $self->new(@args) unless ref $self;
    die $self;
};

sub rethrow {
    push @_, error => $@;
    goto &throw;
};

sub as_string {
    my ($self) = @_;
    return (join ': ', map { $self->$_ } grep { my $has = "has_$_"; $self->$has } $self->string_attributes)
        || ref $self;
};

1;