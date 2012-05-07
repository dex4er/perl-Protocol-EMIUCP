package Protocol::EMIUCP::Message::Role::Field::dcs;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'dcs' => (isa => 'EMIUCP_Bool');

my %Constant_To_Value;

my %Value_To_Description = (
    '0' => 'Default Alphabet',
    '1' => 'User defined data',
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
        *{"${caller}::DCS_$name"} = sub () { $value };
    };
};

sub dcs_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ (defined $code ? $code : $self->{dcs}) || 0 };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{dcs}) {
        $hashref->{dcs_description} = $self->dcs_description;
    };
};

1;
