package Protocol::EMIUCP::Message::Role::Field::otoa;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'otoa' => (isa => 'EMIUCP_Num04', coerce => 1);

my %Constant_To_Value;

my %Value_To_Description = (
    '1139' => 'International',
    '5039' => 'Alphanumeric',
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
        *{"${caller}::OTOA_$name"} = sub () { $value };
    };
};

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (otoa) is invalid with value " . $self->{otoa}
        if defined $self->{otoa} and not exists $Value_To_Description{ $self->{otoa} };
};

sub otoa_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{otoa} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{otoa}) {
        $hashref->{otoa_description} = $self->otoa_description;
    };
};

1;
