package Protocol::EMIUCP::Message::Role::Field::vers;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'vers';

use Carp qw(confess);

sub _build_args_vers {
    my ($class, $args) = @_;

    $args->{vers} = '0100'
        if defined $args->{vers} and not $args->{vers};

    return $class;
};

sub _validate_vers {
    my ($self) = @_;

    confess "Attribute (vers) is invalid"
        if defined $self->{vers} and not $self->{vers} =~ /^\d{4}$/;

    return $self;
};

1;
