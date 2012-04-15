package Protocol::EMIUCP::Message::O;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::Base';

use Carp qw(confess);

sub new {
    my ($class, %args) = @_;

    confess "Attribute (o_r) is invalid, should be 'O'"
        if defined $args{o_r} and $args{o_r} ne 'O';

    $args{o_r} = 'O' unless defined $args{o_r};

    return $class->SUPER::new(%args);
};

1;
