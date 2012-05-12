package Protocol::EMIUCP::Message::Role::Field::dst;

use Moose::Role;

our $VERSION = '0.01';

my %Constant_To_Value;

my %Value_To_Description = (
    '0' => 'Delivered',
    '1' => 'Buffered',
    '2' => 'Not Delivered',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'dst' => (isa => enum([ keys %Value_To_Description ]));

has 'dst_description' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_dst_description',
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{dst} ? $Value_To_Description{ $_[0]->{dst} } : undef },
);

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::DST_$name"} = sub () { $value };
    };
};

1;
