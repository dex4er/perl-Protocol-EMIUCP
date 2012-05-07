package Protocol::EMIUCP::Message::Role::OT_51;

use Moose::Role;

our $VERSION = '0.01';

has '+ot' => (default => '51');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (ot) is invalid with value" . $self->{ot} . ", should be 51"
        if defined $self->{ot} and $self->{ot} ne '51';
};

1;
