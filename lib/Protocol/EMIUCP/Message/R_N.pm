package Protocol::EMIUCP::Message::R_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::R';

sub new {
    my ($class, %args) = @_;

    $args{nack}  = 'N' if $args{nack};

    return $class->SUPER::new(%args);
};

1;
