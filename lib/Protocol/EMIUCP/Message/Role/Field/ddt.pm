package Protocol::EMIUCP::Message::Role::Field::ddt;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Scalar::Util qw(blessed);
use Protocol::EMIUCP::Util qw(has);
eval { require DateTime::Format::EMIUCP::DDT };

has 'ddt';

sub build_ddt_args {
    my ($class, $args) = @_;

    $args->{ddt} = DateTime::Format::EMIUCP::DDT->format_datetime($args->{ddt})
        if blessed $args->{ddt} and $args->{ddt}->isa('DateTime');

    return $class;
};

sub validate_ddt {
    my ($self) = @_;

    confess "Attribute (ddt) is invalid"
        if defined $self->{ddt} and not $self->{ddt}  =~ /^\d{10}$/;

    return $self;
};

sub ddt_datetime {
    my ($self) = @_;

    return unless defined $self->{ddt};
    return DateTime::Format::EMIUCP::DDT->parse_datetime($self->{ddt});
};

sub build_ddt_hashref {
    my ($self, $hashref) = @_;
    if (defined $hashref->{ddt} and eval { DateTime::Format::EMIUCP::DDT->VERSION }) {
        $hashref->{ddt_datetime} = $self->ddt_datetime->datetime;
    };
    return $self;
};

1;