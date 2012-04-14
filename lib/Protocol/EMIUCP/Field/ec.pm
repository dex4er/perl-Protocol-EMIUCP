package Protocol::EMIUCP::Field::ec;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::ec;
use Protocol::EMIUCP::Field;

requires 'list_ec_codes';

before BUILD => sub {
    my ($self) = @_;
    my $ec = $self->ec;
    confess "Validation failed for attribute (ec) with value $ec" unless grep { $_ == $ec } $self->list_ec_codes;
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{ec}) {
        $hashref->{ec}         = $self->ec_string;
        $hashref->{ec_message} = $self->ec_message;
    };
    return $hashref;
};


1;
