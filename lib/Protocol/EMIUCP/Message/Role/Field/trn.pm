package Protocol::EMIUCP::Message::Role::Field::trn;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'trn' => (
    isa      => 'EMIUCP_Num02',
    writer   => '_set_trn',
    coerce   => 1,
    required => 1,
    default  => '00',
);

sub set_trn {
    my ($self, $trn) = @_;
    $self->_set_trn($trn);
    $self->{checksum} = $self->_calculate_checksum;
};

1;
