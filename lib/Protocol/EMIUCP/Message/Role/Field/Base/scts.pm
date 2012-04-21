package Protocol::EMIUCP::Message::Role::Field::Base::scts;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

use Carp qw(confess);
use Scalar::Util qw(blessed);

sub _build_args_base_scts {
    my ($class, $field, $args) = @_;

    my $formatter = 'DateTime::Format::EMIUCP::' . uc($field);

    $args->{$field} = $formatter->format_datetime($args->{$field})
        if blessed $args->{$field} and $args->{$field}->isa('DateTime');

    return $class;
};

sub _validate_base_scts {
    my ($self, $field) = @_;

    confess "Attribute ($field) is invalid"
        if defined $self->{$field} and not $self->{$field}  =~ /^\d{12}$/;

    return $self;
};

sub _base_scts_datetime {
    my ($self, $field) = @_;

    my $formatter = 'DateTime::Format::EMIUCP::' . uc($field);

    return unless defined $self->{$field};
    return $formatter->parse_datetime($self->{$field});
};

sub _build_hashref_base_scts {
    my ($self, $field, $hashref) = @_;

    my $formatter = 'DateTime::Format::EMIUCP::' . uc($field);

    if (defined $hashref->{$field} and eval { $formatter->VERSION }) {
        $hashref->{"${field}_datetime"} = $self->_base_scts_datetime($field)->datetime;
    };
    return $self;
};

1;
