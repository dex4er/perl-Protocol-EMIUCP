package Protocol::EMIUCP::Message::Role::Field::dcs;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'dcs';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '0' => 'Default Alphabet',
    '1' => 'User defined data',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

sub import_dcs {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::DCS_$name"} = sub () { $value };
    };
};

sub build_args_dcs {
    my ($class, $args) = @_;

    $args->{dcs} = $Constant_To_Value{$1}
        if defined $args->{dcs} and $args->{dcs} =~ /^DCS_(.*)$/;

    return $class;
};

sub validate_dcs {
    my ($self) = @_;

    confess "Attribute (dcs) is invalid"
        if defined $self->{dcs} and not exists $Value_To_Description{ $self->{dcs} };

    return $self;
};

sub dcs_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ (defined $code ? $code : $self->{dcs}) || 0 };
};

sub build_hashref_dcs {
    my ($self, $hashref) = @_;
    if (defined $hashref->{dcs}) {
        $hashref->{dcs_description} = $self->dcs_description;
    };
    return $self;
};

1;
