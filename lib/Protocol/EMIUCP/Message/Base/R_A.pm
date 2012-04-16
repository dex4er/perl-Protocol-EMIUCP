package Protocol::EMIUCP::Message::Base::R_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Base::R);

sub new {
    my ($class, %args) = @_;

    $args{ack}  = 'A' if $args{ack};

    return $class->SUPER::new(%args);
};

1;
