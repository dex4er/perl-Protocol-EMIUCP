package Protocol::EMIUCP::Message::Role::Field::checksum;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'checksum';

use Carp qw(confess);
use List::Util qw(sum);

sub _validate_checksum {
    my ($self) = @_;

    confess "Attribute (checksum) is invalid"
        if defined $self->{checksum} and not $self->{checksum} =~ /^[\d[A-F]{2}$/;
    confess "Attribute (checksum) is invalid, should be " . $self->calculate_checksum
        if defined $self->{checksum} and $self->{checksum} ne $self->calculate_checksum;

    return $self;
};

sub calculate_checksum {
    my ($self, $str) = @_;
    $str = $self->as_string if not defined $str;
    $str =~ m{ ^ (.* / ) (?: [0-9A-F]{2} )? $ }x
        or confess "Invalid EMI-UCP message '$str'";
    my $c += sum unpack "C*", $1;
    return sprintf "%02X", $c % 16**2;
};

1;
