package Protocol::EMIUCP::Message::Role::Field::styp;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'styp';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'Add item to MO-List',
    '2' => 'Remove item from MO-List',
    '3' => 'Verify item MO-List',
    '4' => 'Add item to MT-List',
    '5' => 'Remove item from MT-List',
    '6' => 'Verify item MT-List',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

sub _import_styp {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::STYP_$name"} = sub () { $value };
    };
};

sub _build_args_styp {
    my ($class, $args) = @_;

    $args->{styp} = $Constant_To_Value{$1}
        if defined $args->{styp} and $args->{styp} =~ /^STYP_(.*)$/;

    return $class;
};

sub _validate_styp {
    my ($self) = @_;

    confess "Attribute (styp) is invalid"
        if defined $self->{styp} and not grep { $_ eq $self->{styp} } keys %Value_To_Description;

    return $self;
};

sub styp_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{styp} };
};

sub _build_hashref_styp {
    my ($self, $hashref) = @_;
    if (defined $hashref->{styp}) {
        $hashref->{styp_description} = $self->styp_description;
    };
    return $self;
};

1;
