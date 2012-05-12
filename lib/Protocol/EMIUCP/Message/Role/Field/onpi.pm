package Protocol::EMIUCP::Message::Role::Field::onpi;

use Moose::Role;

our $VERSION = '0.01';

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'E.164 Address',
    '3' => 'X121 Address',
    '5' => 'Private',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'onpi' => (isa => enum([ keys %Value_To_Description ]));

has 'onpi_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_onpi_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{onpi} ? $Value_To_Description{ $_[0]->{onpi} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::ONPI_$name"} = sub () { $value };
    };
};

1;
