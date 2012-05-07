package Protocol::EMIUCP::Message::Role::R;

use Moose::Role;

our $VERSION = '0.01';

has '+o_r' => (default => 'R');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (o_r) is invalid with value " . $self->{o_r} . ", should be R"
        if defined $self->{o_r} and $self->{o_r} ne 'R';
    confess "Attribute (ack) or attribute (nack) is required"
        unless $self->{ack} or $self->{nack};
};

1;
