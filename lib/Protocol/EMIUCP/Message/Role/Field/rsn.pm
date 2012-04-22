package Protocol::EMIUCP::Message::Role::Field::rsn;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'rsn';

use constant list_valid_rsn_values => [
    map { sprintf '%03d', $_ } 0..255
];

use Carp qw(confess);

sub _build_args_rsn {
    my ($class, $args) = @_;

    $args->{rsn} = sprintf '%03d', $args->{rsn}
        if defined $args->{rsn} and $args->{rsn} =~ /^\d+$/;

    return $class;
};

sub _validate_rsn {
    my ($self) = @_;

    confess "Attribute (rsn) is invalid"
        if defined $self->{rsn} and not grep { $_ eq $self->{rsn} } @{ $self->list_valid_rsn_values };

    return $self;
};

1;
