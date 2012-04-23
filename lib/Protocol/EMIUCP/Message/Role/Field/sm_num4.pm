package Protocol::EMIUCP::Message::Role::Field::sm_num4;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'sm';

use Carp qw(confess);

sub _build_args_sm_num4 {
    my ($class, $args) = @_;

    $args->{sm} = sprintf '%04d', $args->{sm}
        if defined $args->{sm} and $args->{sm} =~ /^\d{1,4}$/;

    return $class;
};

sub _validate_sm_num4 {
    my ($self) = @_;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and not $self->{sm} =~ /^\d{4}$/;

    return $self;
};

1;
