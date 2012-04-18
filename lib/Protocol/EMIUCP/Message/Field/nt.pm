package Protocol::EMIUCP::Message::Field::nt;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

my %Constant_To_Code = (
    NT_NONE => 0,
    NT_ALL  => 7,
);

my %Code_To_Message;

my %Bits_To_Message = (
    1 => 'BN',
    2 => 'DN',
    4 => 'ND',
);

foreach my $code (1..7) {
    my $message = join '+', grep { $_ } map { $Bits_To_Message{$code & $_} } reverse sort keys %Bits_To_Message;
    $Code_To_Message{$code} = $message;
    my $name = 'NT_' . $message;
    $name =~ s/\W/_/g;
    $Constant_To_Code{$name} = $code;
};

sub import {
    foreach my $name (keys %Constant_To_Code) {
        my $code = $Constant_To_Code{$name};
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::$name"} = sub () { $code };
    };
};

sub build_nt_args {
    my ($class, $args) = @_;

    $args->{nt} = $Constant_To_Code{ $args->{nt} }
        if defined $args->{nt} and $args->{nt} =~ /^NT_/;

    return $class;
};

sub validate_nt {
    my ($self) = @_;

    confess "Attribute (nt) is invalid"
        if defined $self->{nt} and not grep { $_ eq $self->{nt} } 0..7;

    return $self;
};

sub nt_message {
    my ($self, $code) = @_;
    return $Code_To_Message{ defined $code ? $code : $self->{nt} };
};

sub build_nt_hashref {
    my ($self, $hashref) = @_;
    if (defined $hashref->{nt}) {
        $hashref->{nt_message} = $self->nt_message;
    };
    return $self;
};

1;
