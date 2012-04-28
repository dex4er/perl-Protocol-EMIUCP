package Protocol::EMIUCP::Message::Role::Field::onpi;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'onpi';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'E.164 Address',
    '3' => 'X121 Address',
    '5' => 'Private',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

sub _import_onpi {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::ONPI_$name"} = sub () { $value };
    };
};

sub _build_args_onpi {
    my ($class, $args) = @_;

    $args->{onpi} = $Constant_To_Value{$1}
        if defined $args->{onpi} and $args->{onpi} =~ /^ONPI_(.*)$/;

    return $class;
};

sub _validate_onpi {
    my ($self) = @_;

    confess "Attribute (onpi) is invalid"
        if defined $self->{onpi} and not grep { $_ eq $self->{onpi} } keys %Value_To_Description;

    return $self;
};

sub onpi_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{onpi} };
};

sub _build_hashref_onpi {
    my ($self, $hashref) = @_;
    if (defined $hashref->{onpi}) {
        $hashref->{onpi_description} = $self->onpi_description;
    };
    return $self;
};

1;
