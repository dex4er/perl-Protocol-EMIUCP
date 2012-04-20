package Protocol::EMIUCP::Message::Role::Field::dst;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(has);

has 'dst';

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

sub import_dst {
    while (my ($name, $value) = each %Constant_To_Value) {
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::DST_$name"} = sub () { $value };
    };
};

sub build_args_dst {
    my ($class, $args) = @_;

    $args->{dst} = $Constant_To_Value{$1}
        if defined $args->{dst} and $args->{dst} =~ /^DST_(.*)$/;

    return $class;
};

sub validate_dst {
    my ($self) = @_;

    confess "Attribute (dst) is invalid"
        unless grep { $_ eq $self->{dst} } keys %Value_To_Description;

    return $self;
};

sub dst_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{dst} };
};

sub build_hashref_dst {
    my ($self, $hashref) = @_;
    if (defined $hashref->{dst}) {
        $hashref->{dst_description} = $self->dst_description;
    };
    return $self;
};

1;
