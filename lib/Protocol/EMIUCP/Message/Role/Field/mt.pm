package Protocol::EMIUCP::Message::Role::Field::mt;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'mt' => (isa => 'EMIUCP_Num1');

my %Constant_To_Value;

my %Value_To_Description = (
    '2' => 'Numeric',
    '3' => 'Alphanumeric',
    '4' => 'Transparent',
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
        *{"${caller}::MT_$name"} = sub () { $value };
    };
};

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (mt) is invalid with value " . $self->{mt}
        if defined $self->{mt} and not grep { $_ eq $self->{mt} } @{ $self->list_valid_mt_values };
};

sub list_valid_mt_values {
    return [ keys %Value_To_Description ];
};

sub mt_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{mt} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{mt}) {
        $hashref->{mt_description} = $self->mt_description;
    };
};

1;
