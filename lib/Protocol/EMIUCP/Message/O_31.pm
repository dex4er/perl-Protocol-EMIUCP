package Protocol::EMIUCP::Message::O_31;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::O
    Protocol::EMIUCP::Message::Field::pid
);

use Carp qw(confess);
use Scalar::Util qw(looks_like_number);

__PACKAGE__->make_accessors( [qw( adc pid] )] );

sub build_args {
    my ($class, $args) = @_;

    $args->{ot} = '31' unless defined $args->{ot};

    return $class->build_pid_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '31'"
        if defined $self->{ot} and $self->{ot} ne '31';
    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (adc) is invalid"
        unless $self->{adc}  =~ /^\d{1,16}$/;

    return $self;
};

sub list_data_field_names {
    return qw( adc pid );
};

sub list_pid_valid_codes {
    return qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 );
};

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self->build_pid_hashref($hashref);
};

1;
