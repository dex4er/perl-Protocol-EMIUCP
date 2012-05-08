package Protocol::EMIUCP::Message::Role::Field::nt;

use Moose::Role;

our $VERSION = '0.01';

my %Constant_To_Value = (
    NT_NONE => 0,
    NT_ALL  => 7,
);

my %Value_To_Description;

my %Bits_To_Description = (
    1 => 'BN',
    2 => 'DN',
    4 => 'ND',
);

foreach my $value (1..7) {
    my $message = join '+', grep { $_ } map { $Bits_To_Description{$value & $_} } reverse sort keys %Bits_To_Description;
    $Value_To_Description{$value} = $message;
    (my $name = $message) =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'nt' => (isa => enum([ keys %Value_To_Description ]));

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::NT_$name"} = sub () { $value };
    };
};

sub nt_description {
    my ($self, $value) = @_;
    return $Value_To_Description{ defined $value ? $value : $self->{nt} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{nt}) {
        $hashref->{nt_description} = $self->nt_description;
    };
};

1;
