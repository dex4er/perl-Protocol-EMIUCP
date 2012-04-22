package Protocol::EMIUCP::Message::Role::Field::rpl;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'rpl';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'Request',
    '2' => 'Response',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

sub import_rpl {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::RPL_$name"} = sub () { $value };
    };
};

sub build_args_rpl {
    my ($class, $args) = @_;

    $args->{mt} = $Constant_To_Value{$1}
        if defined $args->{rpl} and $args->{rpl} =~ /^RPL_(.*)$/;

    return $class;
};

sub validate_rpl {
    my ($self) = @_;

    confess "Attribute (rpl) is invalid"
        if defined $self->{rpl} and not exists $Value_To_Description{ $self->{rpl} };

    return $self;
};

sub rpl_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{rpl} };
};

sub build_hashref_rpl {
    my ($self, $hashref) = @_;
    if (defined $hashref->{rpl}) {
        $hashref->{rpl_description} = $self->rpl_description;
    };
    return $self;
};

1;
