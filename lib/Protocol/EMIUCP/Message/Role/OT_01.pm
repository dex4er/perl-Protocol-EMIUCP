package Protocol::EMIUCP::Message::Role::OT_01;

use Mouse::Role;

our $VERSION = '0.01';

has '+ot' => (default => '01');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (ot) is invalid with value" . $self->{ot} . ", should be 01"
        if defined $self->{ot} and $self->{ot} ne '01';
};

1;
