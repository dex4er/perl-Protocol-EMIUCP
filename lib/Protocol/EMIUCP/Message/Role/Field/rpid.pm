package Protocol::EMIUCP::Message::Role::Field::rpid;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'rpid' => (isa => 'EMIUCP_Num04', coerce => 1);

use constant list_valid_rpid_values => [
    map { sprintf '%04d', $_ } 0..71, 95, 127, 192..255
];

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (rpid) is invalid with value " . $self->{rpid}
        if defined $self->{rpid} and not grep { $_ eq $self->{rpid} } @{ $self->list_valid_rpid_values };
};

1;
