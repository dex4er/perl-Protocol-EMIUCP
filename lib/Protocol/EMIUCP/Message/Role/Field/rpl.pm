package Protocol::EMIUCP::Message::Role::Field::rpl;

use Moose::Role;

our $VERSION = '0.01';

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'Request',
    '2' => 'Response',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'rpl' => (isa => enum([ keys %Value_To_Description ]));

has 'rpl_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_rpl_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{rpl} ? $Value_To_Description{ $_[0]->{rpl} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::RPL_$name"} = sub () { $value };
    };
};

1;
