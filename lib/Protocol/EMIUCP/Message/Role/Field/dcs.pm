package Protocol::EMIUCP::Message::Role::Field::dcs;

use Mouse::Role;

our $VERSION = '0.01';

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

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'dcs' => (isa => enum([ keys %Value_To_Description ]));

has 'dcs_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_dcs_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{dcs} ? $Value_To_Description{ $_[0]->{dcs} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::DCS_$name"} = sub () { $value };
    };
};

1;
