package Protocol::EMIUCP::Message::Role::Field::Base::Str;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

use Carp qw(confess);
use Scalar::Util qw(blessed);

sub _validate_base_Str {
    my ($self, $field) = @_;

    confess "Attribute ($field) is invalid"
        if defined $self->{$field} and $self->{$field} =~ m{/};

    return $self;
};

1;
