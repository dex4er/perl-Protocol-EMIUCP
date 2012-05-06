package Protocol::EMIUCP::Message::Role::Field::amsg;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'amsg' => (isa => 'EMIUCP_Hex640');

use Protocol::EMIUCP::Encode qw( from_hex_to_utf8 from_utf8_to_hex );

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{amsg} = from_utf8_to_hex delete $args{amsg_utf8}
        if defined $args{amsg_utf8};

    return $class->$orig(%args);
};

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (amsg) is invalid, should be undefined if mt != 3"
        if defined $self->{mt} and $self->{mt} ne 3 and defined $self->{amsg};
};

sub amsg_utf8 {
    my ($self) = @_;
    return from_hex_to_utf8 $self->{amsg}
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    $hashref->{amsg_utf8} = $self->amsg_utf8 if defined $hashref->{amsg};
};

1;
