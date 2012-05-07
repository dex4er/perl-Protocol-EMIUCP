package Protocol::EMIUCP::Message::Role::Field::onpi;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'onpi' => (isa => 'EMIUCP_Num1');

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

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::ONPI_$name"} = sub () { $value };
    };
};

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (onpi) is invalid with value " . $self->{onpi}
        if defined $self->{onpi} and not exists $Value_To_Description{ $self->{onpi} };
};

sub onpi_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{onpi} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{onpi}) {
        $hashref->{onpi_description} = $self->onpi_description;
    };
};

1;
