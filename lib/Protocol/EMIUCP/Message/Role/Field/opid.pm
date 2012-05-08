package Protocol::EMIUCP::Message::Role::Field::opid;

use Mouse::Role;

our $VERSION = '0.01';

my %Constant_To_Value;

my %Value_To_Description = (
    '00' => 'Mobile Station',
    '39' => 'PC Application',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'opid' => (isa => enum([ keys %Value_To_Description ]));

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OPID_$name"} = sub () { $value };
    };
};

sub opid_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{opid} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{opid}) {
        $hashref->{opid_description} = $self->opid_description;
    };
};

1;
