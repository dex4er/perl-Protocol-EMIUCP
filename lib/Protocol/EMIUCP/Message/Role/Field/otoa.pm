package Protocol::EMIUCP::Message::Role::Field::otoa;

use Moose::Role;

our $VERSION = '0.01';

my %Constant_To_Value;

my %Value_To_Description = (
    '1139' => 'International',
    '5039' => 'Alphanumeric',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'otoa' => (isa => enum([ keys %Value_To_Description ]));

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OTOA_$name"} = sub () { $value };
    };
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
