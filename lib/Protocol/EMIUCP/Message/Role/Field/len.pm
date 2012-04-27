package Protocol::EMIUCP::Message::Role::Field::len;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'len';

use Carp qw(confess);

sub _build_args_len {
    my ($class, $args) = @_;

    no warnings 'numeric';
    $args->{len} = sprintf "%05d", $args->{len} if defined $args->{len};

    return $class;
};

sub _validate_len {
    my ($self) = @_;

    confess "Attribute (len) is invalid"
        if defined $self->{len} and not $self->{len} =~ /^\d{5}$/;
    confess "Attribute (len) has invalid value, should be " . $self->_calculate_len
        if defined $self->{len} and $self->{len} ne $self->_calculate_len;

    return $self;
};

sub _calculate_len {
    my ($self, $str) = @_;
    $str = $self->as_string if not defined $str;

    my $len = length $str;

    $str =~ m{ ^ \d{2} / ( \d{5} )? / }x
        or confess "Invalid EMI-UCP message '$str'";
    $len += 5 if not defined $1;

    $str =~ m{ / ( [0-9A-F]{2} )? $ }x
        or confess "Invalid EMI-UCP message '$str'";
    $len += 2 if not defined $1;

    return sprintf "%05d", $len;
};

1;
