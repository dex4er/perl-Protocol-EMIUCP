package Protocol::EMIUCP::Message::Role::Field::oton;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'oton';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'International',
    '2' => 'National',
    '6' => 'Abbreviated',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

sub _import_oton {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OTON_$name"} = sub () { $value };
    };
};

sub _build_args_oton {
    my ($class, $args) = @_;

    $args->{oton} = $Constant_To_Value{$1}
        if defined $args->{oton} and $args->{oton} =~ /^OTON_(.*)$/;

    return $class;
};

sub _validate_oton {
    my ($self) = @_;

    confess "Attribute (oton) is invalid"
        if defined $self->{oton} and not grep { $_ eq $self->{oton} } keys %Value_To_Description;

    return $self;
};

sub oton_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{oton} };
};

sub _build_hashref_oton {
    my ($self, $hashref) = @_;
    if (defined $hashref->{oton}) {
        $hashref->{oton_description} = $self->oton_description;
    };
    return $self;
};

1;
