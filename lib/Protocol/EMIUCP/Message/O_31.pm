package Protocol::EMIUCP::Message::O_31;

use 5.008;

our $VERSION = '0.01';

use Moose;

with 'Protocol::EMIUCP::Message::Role::O';
with 'Protocol::EMIUCP::Message::Role::OT_31';

use Protocol::EMIUCP::Field;

has_field [qw( adc )];
with_field 'pid';

sub BUILD {
    my ($self) = @_;
    confess 'OT != 31' if $self->ot != 31;
};

sub list_data_field_names {
    return qw( adc pid );
};


__PACKAGE__->meta->make_immutable();

1;
