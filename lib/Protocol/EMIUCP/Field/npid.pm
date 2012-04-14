package Protocol::EMIUCP::Field::npid;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::pid;
use Protocol::EMIUCP::Field;

requires 'list_npid_codes';

before BUILD => sub {
    my ($self) = @_;
    my $npid = $self->npid;
    confess "Validation failed for attribute (npid) with value $npid" unless grep { $_ == $npid } $self->list_npid_codes;
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{npid}) {
        $hashref->{npid}         = $self->npid_as_string;
        $hashref->{npid_message} = $self->npid_message;
    };
    return $hashref;
};


1;
