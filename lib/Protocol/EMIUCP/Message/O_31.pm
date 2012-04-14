package Protocol::EMIUCP::Message::O_31;

use 5.006;

our $VERSION = '0.01';

use Moose;

with 'Protocol::EMIUCP::Message::Role::O';
with 'Protocol::EMIUCP::Message::Role::OT_31';

use Protocol::EMIUCP::Field;

has_field [qw( adc )];
with_field 'pid';

sub list_data_field_names {
    return qw( adc pid );
};

sub list_pid_codes {
    return qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 );
};

__PACKAGE__->meta->make_immutable();

1;
