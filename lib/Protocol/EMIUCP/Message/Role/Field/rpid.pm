package Protocol::EMIUCP::Message::Role::Field::rpid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'rpid';

use constant list_valid_rpid_values => [
    map { sprintf '%04d', $_ } 0..71, 95, 127, 192..255
];

use Carp qw(confess);

sub build_args_rpid {
    my ($class, $args) = @_;

    $args->{rpid} = sprintf '%04d', $args->{rpid}
        if defined $args->{rpid} and $args->{rpid} =~ /^\d+$/;

    return $class;
};

sub validate_rpid {
    my ($self) = @_;

    confess "Attribute (rpid) is invalid"
        if defined $self->{rpid} and not grep { $_ eq $self->{rpid} } @{ $self->list_valid_rpid_values };

    return $self;
};

1;
