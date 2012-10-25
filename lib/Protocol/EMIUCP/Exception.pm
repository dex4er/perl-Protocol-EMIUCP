package Protocol::EMIUCP::Exception;

use Mouse;

use overload '""' => 'as_string', fallback => 1;

$Carp::Internal{ (__PACKAGE__) }++;

has 'message' => (
    isa       => 'Str',
    is        => 'ro',
    predicate => 'has_message',
);

has 'error' => (
    isa       => 'Any',
    is        => 'ro',
    predicate => 'has_error',
    trigger   => sub {
        my ($self, $error) = @_;
        while ($error =~ s/\t\.\.\.propagated at (?!.*\bat\b.*).* line \d+( thread \d+)?\.\n$//s) { };
        $error =~ s/ at .* line \d+( thread \d+)?\.\n.*//s;
        $self->{error} = $error;
    },
);

has 'stacktrace' => (
    isa       => 'Str',
    is        => 'ro',
    predicate => 'has_stacktrace',
    default   => sub { local $@; eval { confess '' }; "$@" },
);

has 'string_attributes' => (
    isa       => 'ArrayRef[Str]',
    is        => 'ro',
    default   => sub { [qw( message error )] },
);

sub throw {
    my ($self, @args) = @_;
    $self = $self->new($@ ? (error => $@) : (), @args) unless ref $self;
    die $self;
};

sub as_string {
    my ($self) = @_;
    my $string = (join ': ', map { $self->$_ } grep { my $has = "has_$_"; $self->$has } @{ $self->string_attributes }) || ref $self;
    $string .= $self->stacktrace if $self->has_stacktrace;
    return $string;
};

__PACKAGE__->meta->make_immutable;

no Mouse;

1;
