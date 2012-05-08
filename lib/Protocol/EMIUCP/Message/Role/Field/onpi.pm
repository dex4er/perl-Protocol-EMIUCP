package Protocol::EMIUCP::Message::Role::Field::onpi;

use Mouse::Role;

our $VERSION = '0.01';

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

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'onpi' => (isa => enum([ keys %Value_To_Description ]));

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::ONPI_$name"} = sub () { $value };
    };
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
