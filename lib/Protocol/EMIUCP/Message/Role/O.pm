package Protocol::EMIUCP::Message::Role::O;

use Moose::Role;

our $VERSION = '0.01';

has '+o_r' => (default => 'O');

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (o_r) is invalid with value " . $self->{o_r} . ", should be O"
        if defined $self->{o_r} and $self->{o_r} ne 'O';
};

1;
