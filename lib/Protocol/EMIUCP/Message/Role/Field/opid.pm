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

has 'opid_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_opid_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{opid} ? $Value_To_Description{ $_[0]->{opid} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::OPID_$name"} = sub () { $value };
    };
};

1;
