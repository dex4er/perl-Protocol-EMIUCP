package Protocol::EMIUCP::Message::Role::Field::len;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'len' => (isa => 'EMIUCP_Num05', coerce => 1);

after BUILD => sub {
    my ($self) = @_;

    my $len = $self->_calculate_len;
    confess "Attribute (len) has invalid value " . $self->{len} .
        ", should be " . $len .
        " for message " . $self->as_string
        if defined $self->{len} and $self->{len} ne $len;
};

sub _calculate_len {
    my ($self, $str) = @_;
    $str = $self->_as_string if not defined $str;

    my $len = length $str;

    $str =~ m{ ^ \d{2} / ( \d{5} )? / }x
        or confess "Invalid EMI-UCP message '$str'";
    $len += 5 if not defined $1;

    $str =~ m{ / ( [0-9A-F]{2} )? $ }x
        or confess "Invalid EMI-UCP message '$str'";
    $len += 2 if not defined $1;

    return sprintf "%05d", $len;
};

1;
