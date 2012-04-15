package Protocol::EMIUCP::Message::R;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::Base';

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( ack nack )] );

sub new {
    my ($class, %args) = @_;

    confess "Attribute (o_r) is invalid, should be 'R'"
        if defined $args{o_r} and $args{o_r} ne 'R';
    confess "Attribute (ack) or attribute (nack) is required"
        unless $args{ack} or $args{nack};

    $args{o_r}  = 'R' unless defined $args{o_r};

    return $class->SUPER::new(%args);
};

1;
