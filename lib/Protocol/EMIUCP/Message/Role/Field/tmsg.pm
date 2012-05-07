package Protocol::EMIUCP::Message::Role::Field::tmsg;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'tmsg' => (isa => 'EMIUCP_Hex1403');

use Protocol::EMIUCP::Encode qw( decode_hex encode_hex );

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{tmsg} = encode_hex delete $args{tmsg_binary}
        if defined $args{tmsg_binary};

    # one char from tmsg is 4 bits
    $args{nb} = 4 * length $args{tmsg}
        if not defined $args{nb} and defined $args{tmsg};

    return $class->$orig(%args);
};

before BUILD => sub {
    my ($self) = @_;

    confess "Attribute (tmsg) is invalid, should be undefined if mt != 4"
        if defined $self->{mt} and $self->{mt} != 4 and defined $self->{tmsg};
};

sub tmsg_binary {
    my ($self) = @_;
    return decode_hex $self->{tmsg}
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    $hashref->{tmsg_binary} = $self->tmsg_binary if defined $hashref->{tmsg};
    return $self;
};

1;
