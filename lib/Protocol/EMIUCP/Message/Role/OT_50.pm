package Protocol::EMIUCP::Message::Role::OT_50;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

sub list_data_field_names {
    return qw( adc oadc ac nrq nadc nt );
};


1;
