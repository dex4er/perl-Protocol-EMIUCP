package Protocol::EMIUCP::Message::Role::Field::nb;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'nb' => (isa => 'EMIUCP_Num4');

use Carp qw(confess);

before BUILD => sub {
    my ($self) = @_;

    if (defined $self->{mt} and $self->{mt} == 4) {
        confess "Attribute (nb) is required if attribute (mt) == 4"
            unless defined $self->{nb};
        # TODO mcl is required if XSer "GSM DCS information" is not supplied
    };
};

1;
