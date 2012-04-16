package Protocol::EMIUCP::Message::R_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::R';

sub new {
    my ($class, %args) = @_;

    $args{ack}  = 'A' if $args{ack};

    return $class->SUPER::new(%args);
};

1;
