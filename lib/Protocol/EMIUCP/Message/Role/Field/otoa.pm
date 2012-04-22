package Protocol::EMIUCP::Message::Role::Field::otoa;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'otoa';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '1139' => 'International',
    '5039' => 'Alphanumeric',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

sub import_otoa {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OTOA_$name"} = sub () { $value };
    };
};

sub build_args_otoa {
    my ($class, $args) = @_;

    $args->{otoa} = $Constant_To_Value{$1}
        if defined $args->{otoa} and $args->{otoa} =~ /^OTOA_(.*)$/;

    return $class;
};

sub validate_otoa {
    my ($self) = @_;

    confess "Attribute (otoa) is invalid"
        if defined $self->{otoa} and not exists $Value_To_Description{ $self->{otoa} };

    return $self;
};

sub otoa_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{otoa} };
};

sub build_hashref_otoa {
    my ($self, $hashref) = @_;
    if (defined $hashref->{otoa}) {
        $hashref->{otoa_description} = $self->otoa_description;
    };
    return $self;
};

1;
