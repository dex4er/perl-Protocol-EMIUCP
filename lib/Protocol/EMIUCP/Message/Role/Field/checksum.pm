package Protocol::EMIUCP::Message::Role::Field::checksum;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'checksum' => (isa => 'EMIUCP_Hex02');

use List::Util qw(sum);

after BUILD => sub {
    my ($self) = @_;

    my $checksum = $self->_calculate_checksum;
    confess "Attribute (checksum) has invalid value " . $self->{checksum} .
        ", should be " . $checksum .
        " for message " . $self->as_string
        if defined $self->{checksum} and $self->{checksum} ne $checksum;
};

sub _calculate_checksum {
    my ($self, $str) = @_;
    $str = $self->_build_string if not defined $str;
    $str =~ m{ ^ (.* / ) (?: [0-9A-F]{2} )? $ }x
        or confess "Invalid EMI-UCP message '$str'";
    my $c += sum unpack "C*", $1;
    return sprintf "%02X", $c % 0x100;
};

1;
