package Protocol::EMIUCP::Message::O_31;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::O
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has with_field );

has 'adc';
with_field 'pid';

use constant list_data_field_names => [ qw( adc pid ) ];

use constant list_valid_pid_values => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 ) ];

sub import {
    my ($class, %args) = @_;
    $args{caller} = caller() unless defined $args{caller};
    $class->import_pid(\%args);
};

sub validate {
    my ($self) = @_;

    $self->SUPER::validate;

    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (adc) is invalid"
        unless $self->{adc}  =~ /^\d{1,16}$/;

    return $self;
};

1;
