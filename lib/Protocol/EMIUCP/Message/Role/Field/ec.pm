package Protocol::EMIUCP::Message::Role::Field::ec;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'ec';

use Carp qw(confess);

my %Constant_To_Value;

my %Value_To_Description = (
    '01' => 'Checksum error',
    '02' => 'Syntax error',
    '03' => 'Operation not supported by system',
    '04' => 'Operation not allowed',
    '05' => 'Call barring active',
    '06' => 'AdC invalid',
    '07' => 'Authentication failure',
    '08' => 'Legitimisation code for all calls, failure',
    '23' => 'Description type not supported by system',
    '24' => 'Description too long',
    '26' => 'Description type not valid for the pager type',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W+/_/g;
    $Constant_To_Value{$name} = $value;
};

sub _import_ec {
    my ($class, $args) = @_;
    my $caller = $args->{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::EC_$name"} = sub () { $value };
    };
};

sub _build_args_ec {
    my ($class, $args) = @_;

    $args->{ec} = $Constant_To_Value{$1}
        if defined $args->{ec} and $args->{ec} =~ /^EC_(.*)$/;

    return $class;
};

sub _validate_ec {
    my ($self) = @_;

    confess "Attribute (ec) is required"
        unless defined $self->{ec};
    confess "Attribute (ec) is invalid"
        unless grep { $_ eq $self->{ec} } @{ $self->list_valid_ec_values };

    return $self;
};

sub list_valid_ec_values {
    confess "Method (list_valid_ec_values) have to be overrided by derived class method";
};

sub ec_description {
    my ($self, $value) = @_;
    return $Value_To_Description{ defined $value ? $value : $self->{ec} };
};

sub _build_hashref_ec {
    my ($self, $hashref) = @_;
    if (defined $hashref->{ec}) {
        $hashref->{ec_description} = $self->ec_description;
    };
    return $self;
};


1;
