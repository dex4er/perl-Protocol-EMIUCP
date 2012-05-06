package Protocol::EMIUCP::Message::Role::Field::nmsg;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'nmsg' => (isa => 'EMIUCP_Num160');

before 'BUILD' => sub {
    my ($self) = @_;

    confess "Attribute (nmsg) is invalid, should be undefined if mt != 2"
        if defined $self->{mt} and $self->{mt} ne 2 and defined $self->{nmsg};
};

1;
