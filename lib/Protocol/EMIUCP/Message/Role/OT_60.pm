package Protocol::EMIUCP::Message::Role::OT_60;

use Moose::Role;

our $VERSION = '0.01';

has '+ot' => (default => '60');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (ot) is invalid with value" . $self->{ot} . ", should be 60"
        if defined $self->{ot} and $self->{ot} ne '60';
};

1;
