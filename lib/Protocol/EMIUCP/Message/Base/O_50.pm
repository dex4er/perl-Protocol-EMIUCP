package Protocol::EMIUCP::Message::Base::O_50;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Base::O);

__PACKAGE__->make_accessors( [qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd )] );

use constant list_data_field_names => [ qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd ) ];

1;
