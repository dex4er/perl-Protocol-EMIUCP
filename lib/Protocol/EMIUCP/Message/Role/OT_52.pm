package Protocol::EMIUCP::Message::Role::OT_52;

use Moose::Role;

our $VERSION = '0.01';

has '+ot' => (default => '52');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (ot) is invalid with value" . $self->{ot} . ", should be 52"
        if defined $self->{ot} and $self->{ot} ne '52';
};

1;
