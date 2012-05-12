package Protocol::EMIUCP::Message::Role::Field::oton;

use Mouse::Role;

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

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'oton' => (isa => enum([ keys %Value_To_Description ]));

has 'oton_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_oton_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{oton} ? $Value_To_Description{ $_[0]->{oton} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OTON_$name"} = sub () { $value };
    };
};

1;
