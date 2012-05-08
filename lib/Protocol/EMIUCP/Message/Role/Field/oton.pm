package Protocol::EMIUCP::Message::Role::Field::oton;

use Moose::Role;

our $VERSION = '0.01';

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

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'oton' => (isa => enum([ keys %Value_To_Description ]));

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OTON_$name"} = sub () { $value };
    };
};

sub oton_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{oton} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{oton}) {
        $hashref->{oton_description} = $self->oton_description;
    };
};

1;
