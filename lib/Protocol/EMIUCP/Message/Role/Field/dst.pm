package Protocol::EMIUCP::Message::Role::Field::dst;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'dst';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '0' => 'Delivered',
    '1' => 'Buffered',
    '2' => 'Not Delivered',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

sub _import_dst {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::DST_$name"} = sub () { $value };
    };
};

sub _build_args_dst {
    my ($class, $args) = @_;

    $args->{dst} = $Constant_To_Value{$1}
        if defined $args->{dst} and $args->{dst} =~ /^DST_(.*)$/;

    return $class;
};

sub _validate_dst {
    my ($self) = @_;

    confess "Attribute (dst) is invalid"
        if defined $self->{dst} and not grep { $_ eq $self->{dst} } keys %Value_To_Description;

    return $self;
};

sub dst_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{dst} };
};

sub _build_hashref_dst {
    my ($self, $hashref) = @_;
    if (defined $hashref->{dst}) {
        $hashref->{dst_description} = $self->dst_description;
    };
    return $self;
};

1;
