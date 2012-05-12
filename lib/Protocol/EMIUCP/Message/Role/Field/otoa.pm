package Protocol::EMIUCP::Message::Role::Field::otoa;

use Mouse::Role;

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

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'otoa' => (isa => enum([ keys %Value_To_Description ]));

has 'otoa_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_otoa_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{otoa} ? $Value_To_Description{ $_[0]->{otoa} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OTOA_$name"} = sub () { $value };
    };
};

1;
