package Protocol::EMIUCP::Message::O_31;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::O
    Protocol::EMIUCP::Message::Base::OT_31
    Protocol::EMIUCP::Message::Field::pid
);

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( adc pid )] );

sub import {
    my ($class, %args) = @_;
    $args{caller} = caller() unless defined $args{caller};
    $class->import_pid(\%args);
};

sub build_args {
    my ($class, $args) = @_;
    return $class
        ->build_ot_31_args($args)
        ->build_pid_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (adc) is invalid"
        unless $self->{adc}  =~ /^\d{1,16}$/;

    return $self
        ->SUPER::validate
        ->validate_ot_31;
};

use constant list_data_field_names => [ qw( adc pid ) ];

use constant list_valid_pid_codes => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 ) ];

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self
        ->build_pid_hashref($hashref);
};

1;
