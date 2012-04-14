package Protocol::EMIUCP::Field::lpid;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::pid;
use Protocol::EMIUCP::Field;

requires 'list_lpid_codes';

before BUILD => sub {
    my ($self) = @_;
    my $lpid = $self->lpid;
    confess "Validation failed for attribute (lpid) with value $lpid" unless grep { $_ == $lpid } $self->list_lpid_codes;
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{lpid}) {
        $hashref->{lpid}         = $self->lpid_as_string;
        $hashref->{lpid_message} = $self->lpid_message;
    };
    return $hashref;
};


1;
