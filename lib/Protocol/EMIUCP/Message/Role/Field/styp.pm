package Protocol::EMIUCP::Message::Role::Field::styp;

use Moose::Role;

our $VERSION = '0.01';

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

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'styp' => (isa => enum([ keys %Value_To_Description ]));

has 'styp_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_styp_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{styp} ? $Value_To_Description{ $_[0]->{styp} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::STYP_$name"} = sub () { $value };
    };
};

1;
