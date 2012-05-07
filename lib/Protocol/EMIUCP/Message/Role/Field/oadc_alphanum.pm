package Protocol::EMIUCP::Message::Role::Field::oadc_alphanum;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'oadc' => (isa => 'EMIUCP_Num16 | EMIUCP_Hex22');

use Protocol::EMIUCP::Encode qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{oadc} = from_utf8_to_7bit_hex delete $args{oadc_utf8}
        if defined $args{oadc_utf8};

    return $class->$orig(%args);
};

before BUILD => sub {
    my ($self) = @_;

    if (defined $self->{otoa} and $self->{otoa} eq '5039') {
        confess "Attribute (oadc) is invalid"
            if defined $self->{oadc} and not $self->{oadc} =~ /^[\dA-F]{2,22}$/;
    }
    else {
        confess "Attribute (oadc) is invalid"
            if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}$/;
    };
};

sub oadc_utf8 {
    my ($self) = @_;
    return from_7bit_hex_to_utf8 $self->{oadc};
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{oadc}) {
        $hashref->{oadc_utf8} = $self->oadc_utf8
            if defined $self->{otoa} and $self->{otoa} eq '5039';
    };
};

1;
