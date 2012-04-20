package Protocol::EMIUCP::Message::Role::Field::mt;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(has);

has 'mt';

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

sub import_mt {
    while (my ($name, $value) = each %Constant_To_Value) {
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::MT_$name"} = sub () { $value };
    };
};

sub build_args_mt {
    my ($class, $args) = @_;

    $args->{mt} = $Constant_To_Value{$1}
        if defined $args->{mt} and $args->{mt} =~ /^MT_(.*)$/;

    no warnings 'numeric';
    confess "Attribute (nmsg) is invalid, should be undefined if mt != 2"
        if defined $args->{mt} and $args->{mt} != 2 and defined $args->{nmsg};
    confess "Attribute (amsg) is invalid, should be undefined if mt != 3"
        if defined $args->{mt} and $args->{mt} != 3 and defined $args->{amsg};
    confess "Attribute (tmsg) is invalid, should be undefined if mt != 4"
        if defined $args->{mt} and $args->{mt} != 4 and defined $args->{tmsg};

    return $class;
};

sub validate_mt {
    my ($self) = @_;

    confess "Attribute (mt) is invalid"
        if defined $self->{mt} and not grep { $_ eq $self->{mt} } @{ $self->list_valid_mt_values };

    return $self;
};

sub list_valid_mt_values {
    confess "Method (list_mt_valid_values) have to be overrided by derived class method";
};

sub mt_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{mt} };
};

sub build_hashref_mt {
    my ($self, $hashref) = @_;
    if (defined $hashref->{mt}) {
        $hashref->{mt_description} = $self->mt_description;
    };
    return $self;
};

1;
