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

foreach my $code (1..7) {
    my $message = join '+', grep { $_ } map { $Bits_To_Description{$code & $_} } reverse sort keys %Bits_To_Description;
    $Value_To_Description{$code} = $message;
    my $name = 'NT_' . $message;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $code;
};

sub import_nt {
    foreach my $name (keys %Constant_To_Value) {
        my $code = $Constant_To_Value{$name};
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::$name"} = sub () { $code };
    };
};

sub build_nt_args {
    my ($class, $args) = @_;

    $args->{nt} = $Constant_To_Value{ $args->{nt} }
        if defined $args->{nt} and $args->{nt} =~ /^NT_/;

    return $class;
};

sub validate_nt {
    my ($self) = @_;

    confess "Attribute (nt) is invalid"
        if defined $self->{nt} and not grep { $_ eq $self->{nt} } 0..7;

    return $self;
};

sub nt_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{nt} };
};

sub build_nt_hashref {
    my ($self, $hashref) = @_;
    if (defined $hashref->{nt}) {
        $hashref->{nt_description} = $self->nt_description;
    };
    return $self;
};

1;
