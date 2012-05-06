package Protocol::EMIUCP::Message::Role::Field::styp;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'styp' => (isa => 'EMIUCP_Num1');

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

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::STYP_$name"} = sub () { $value };
    };
};

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (styp) is invalid with value " . $self->{styp}
        if defined $self->{styp} and not exists $Value_To_Description{ $self->{styp} };
};

sub styp_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{styp} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{styp}) {
        $hashref->{styp_description} = $self->styp_description;
    };
};

1;
