package Protocol::EMIUCP::Message::Field::ec;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

my %Constant_To_ID;
my %ID_To_Message = (
    '01' => 'Checksum error',
    '02' => 'Syntax error',
    '03' => 'Operation not supported by system',
    '04' => 'Operation not allowed',
    '05' => 'Call barring active',
    '06' => 'AdC invalid',
    '07' => 'Authentication failure',
    '08' => 'Legitimisation code for all calls, failure',
    '23' => 'Message type not supported by system',
    '24' => 'Message too long',
    '26' => 'Message type not valid for the pager type',
);

foreach my $id (keys %ID_To_Message) {
    my $name = 'EC_' . $ID_To_Message{$id};
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W+/_/g;
    $Constant_To_ID{$name} = $id;
};

sub import {
    foreach my $name (keys %Constant_To_ID) {
        my $id = $Constant_To_ID{$name};
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::$name"} = sub () { $id };
    };
};

sub build_ec_args {
    my ($class, $args) = @_;

    $args->{ec} = $Constant_To_ID{ $args->{ec} }
        if defined $args->{ec} and $args->{ec} =~ /^EC_/;

    return $class;
};

sub validate_ec {
    my ($self) = @_;

    confess "Attribute (ec) is required"
        unless defined $self->{ec};
    confess "Attribute (ec) is invalid"
        unless grep { $_ eq $self->{ec} } $self->list_ec_codes;

    return $self;
};

sub list_ec_codes {
    confess "Method (list_ec_codes) have to be overrided by derived class method";
};

sub ec_message {
    my ($self, $ec) = @_;
    return $ID_To_Message{ defined $ec ? $ec : $self->{ec} };
};

sub build_ec_hashref {
    my ($self, $hashref) = @_;
    if (defined $hashref->{ec}) {
        $hashref->{ec_message} = $self->ec_message;
    };
    return $self;
};


1;
