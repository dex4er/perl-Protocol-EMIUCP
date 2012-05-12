package Protocol::EMIUCP::Message::Role::Field::mt;

use Mouse::Role;

our $VERSION = '0.01';

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

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'mt' => (isa => enum([ keys %Value_To_Description ]));

has 'mt_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_mt_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{mt} ? $Value_To_Description{ $_[0]->{mt} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::MT_$name"} = sub () { $value };
    };
};

1;
