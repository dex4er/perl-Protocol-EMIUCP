package Protocol::EMIUCP::Message::R_31_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::R_A
    Protocol::EMIUCP::Message::Base::OT_31
);

use Carp qw(confess);
use Scalar::Util qw(looks_like_number);

__PACKAGE__->make_accessors( [qw( sm )] );

sub build_args {
    my ($class, $args) = @_;

    $args->{sm} = sprintf '%04d', $args->{sm}
        if defined $args->{sm} and looks_like_number $args->{sm};

    return $class
        ->build_ot_31_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and not $self->{sm} =~ /^\d{4}$/;

    return $self
        ->SUPER::validate
        ->validate_ot_31;
};

use constant list_data_field_names => [ qw( ack sm ) ];

1;
