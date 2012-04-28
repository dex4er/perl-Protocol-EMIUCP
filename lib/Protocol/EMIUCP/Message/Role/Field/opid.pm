package Protocol::EMIUCP::Message::Role::Field::opid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'opid';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '00' => 'Mobile Station',
    '39' => 'PC Application',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

sub _import_opid {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OPID_$name"} = sub () { $value };
    };
};

sub _build_args_opid {
    my ($class, $args) = @_;

    $args->{opid} = $Constant_To_Value{$1}
        if defined $args->{opid} and $args->{opid} =~ /^OPID_(.*)$/;

    return $class;
};

sub _validate_opid {
    my ($self) = @_;

    confess "Attribute (opid) is invalid"
        if defined $self->{opid} and not grep { $_ eq $self->{opid} } keys %Value_To_Description;

    return $self;
};

sub opid_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{opid} };
};

sub _build_hashref_opid {
    my ($self, $hashref) = @_;
    if (defined $hashref->{opid}) {
        $hashref->{opid_description} = $self->opid_description;
    };
    return $self;
};

1;
