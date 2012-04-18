package Protocol::EMIUCP::Message::Role::Field::nt;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

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

sub import_nt {
    while (my ($name, $value) = each %Constant_To_Value) {
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::NT_$name"} = sub () { $value };
    };
};

sub build_nt_args {
    my ($class, $args) = @_;

    $args->{nt} = $Constant_To_Value{$1}
        if defined $args->{nt} and $args->{nt} =~ /^NT_(.*)$/;

    return $class;
};

sub validate_nt {
    my ($self) = @_;

    confess "Attribute (nt) is invalid"
        if defined $self->{nt} and not grep { $_ eq $self->{nt} } 0..7;

    return $self;
};

sub nt_description {
    my ($self, $value) = @_;
    return $Value_To_Description{ defined $value ? $value : $self->{nt} };
};

sub build_nt_hashref {
    my ($self, $hashref) = @_;
    if (defined $hashref->{nt}) {
        $hashref->{nt_description} = $self->nt_description;
    };
    return $self;
};

1;
