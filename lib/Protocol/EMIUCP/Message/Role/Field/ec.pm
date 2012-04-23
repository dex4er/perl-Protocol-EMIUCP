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
    '01' => 'Checksum Error',
    '02' => 'Syntax Error',
    '03' => 'Operation Not Supported by System',
    '04' => 'Operation Not Allowed',
    '05' => 'Call Barring Active',
    '06' => 'AdC Invalid',
    '07' => 'Authentication Failure',
    '08' => 'Legitimisation Code for All Calls, Failure',
    '09' => 'GA Not Valid',
    '10' => 'Repetition Not Allowed',
    '11' => 'Legitimisation Code for Repetition, Failure',
    '12' => 'Priority Call Not Allowed',
    '13' => 'Legitimisation Code for Priority Call, Failure',
    '14' => 'Urgent Message Not Allowed',
    '15' => 'Legitimisation Code for Urgent Message, Failure',
    '16' => 'Reverse Charging Not Allowed',
    '17' => 'Legitimisation Code for Rev. Charging, Failure',
    '18' => 'Deferred Delivery Not Allowed',
    '19' => 'New AC Not Valid',
    '20' => 'New Legitimisation Code Not Valid',
    '21' => 'Standard Text Not Valid',
    '22' => 'Time Period Not Valid',
    '23' => 'Message Type Not Supported by System',
    '24' => 'Message too Long',
    '25' => 'Requested Standard Text Not Valid',
    '26' => 'Message Type Not Valid for the Pager Type',
    '27' => 'Message not found in SMSC',
    '30' => 'Subscriber Hang-up',
    '31' => 'Fax Group Not Supported',
    '32' => 'Fax Message Type Not Supported',
    '33' => 'Address already in List',
    '34' => 'Address not in List',
    '35' => 'List full, cannot add Address to List',
    '36' => 'RPID already in Use',
    '37' => 'Delivery in Progress',
    '38' => 'Message Forwarded',
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
    return [ keys %Value_To_Description ];
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
