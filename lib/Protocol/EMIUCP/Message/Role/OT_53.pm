package Protocol::EMIUCP::Message::Role::OT_53;

use Moose::Role;

our $VERSION = '0.01';

has '+ot' => (default => '53');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (ot) is invalid with value" . $self->{ot} . ", should be 53"
        if defined $self->{ot} and $self->{ot} ne '53';
};

1;
