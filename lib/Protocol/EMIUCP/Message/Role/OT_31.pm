package Protocol::EMIUCP::Message::Role::OT_31;

use Moose::Role;

our $VERSION = '0.01';

has '+ot' => (default => '31');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (ot) is invalid with value" . $self->{ot} . ", should be 31"
        if defined $self->{ot} and $self->{ot} ne '31';
};

1;
