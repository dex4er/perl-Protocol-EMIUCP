package Protocol::EMIUCP::OO::Role::BuildArgs;

use Mouse::Role;

our $VERSION = '0.01';

has '_build_args' => (
    is         => 'ro',
    isa        => 'HashRef',
    auto_deref => 1,
    required   => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my $args = $class->$orig(@args);

    $args->{_build_args} = { %$args };

    return $args;
};

1;
