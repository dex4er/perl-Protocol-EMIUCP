package Protocol::EMIUCP::Message::O_31;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::O
);
extends qw(Protocol::EMIUCP::Message::Object);

has_field [qw( adc pid )];

use constant list_valid_pid_values => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 ) ];

use constant list_data_field_names => [ qw( adc pid ) ];
use constant list_required_field_names => [ qw( adc pid ) ];

use Carp qw(confess);

1;
