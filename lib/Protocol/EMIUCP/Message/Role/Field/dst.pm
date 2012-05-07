package Protocol::EMIUCP::Message::Role::Field::dst;

use Moose::Role;

our $VERSION = '0.01';

use Moose::Util::TypeConstraints;

enum 'EMIUCP_Dst' => [qw( 0 1 2 )];

use Protocol::EMIUCP::Message::Field;

has_field 'dst' => (isa => 'EMIUCP_Dst');

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

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::DST_$name"} = sub () { $value };
    };
};

sub dst_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{dst} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{dst}) {
        $hashref->{dst_description} = $self->dst_description;
    };
};

1;
