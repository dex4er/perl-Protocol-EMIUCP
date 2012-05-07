package Protocol::EMIUCP::Message::O_31;

use Moose;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::O
);

with_field [qw( adc pid )];
required_field [qw( adc pid )];

use constant list_data_field_names => [qw( adc pid )];

use constant list_valid_pid_values => [qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 )];

__PACKAGE__->meta->make_immutable();

1;
