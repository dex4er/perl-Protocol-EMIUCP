package Protocol::EMIUCP::Message;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';


# Factory class

use Carp qw(confess);
use Scalar::Util qw(looks_like_number);
use Protocol::EMIUCP::Util;


sub _find_new_class_from_args {
    my ($class, $args) = @_;

    confess "Attribute (ot) is required"
        unless defined $args->{ot};
    confess "Attribute (ot) has invalid value '$args->{ot}', should be larger than 0"
        unless looks_like_number $args->{ot} and $args->{ot} > 0;
    confess "Attribute (o_r) is required"
        unless defined $args->{o_r};
    confess "Attribute (o_r) has invalid value '$args->{o_r}', should be 'O' or 'R'"
        unless $args->{o_r} eq 'O' or $args->{o_r} eq 'R';
    confess "Attribute (ack) xor (nack) is required if (o_r) eq 'R'"
        if $args->{o_r} eq 'R' and not ($args->{ack} xor $args->{nack});

    my $new_class = sprintf 'Protocol::EMIUCP::Message::%s_%02d', $args->{o_r}, $args->{ot};
    $new_class .= '_A' if defined $args->{ack};
    $new_class .= '_N' if defined $args->{nack};

    Protocol::EMIUCP::Util::load_class($new_class);
    return $new_class;
};


sub _find_new_class_from_string {
    my ($class, $str) = @_;

    $str =~ m{ ^ \d{2} / \d{5} / ( [OR] ) / ( \d{2} ) / (?: ( [AN] ) / )? .* / [0-9A-F]{2} $ }x
        or confess "Invalid EMI-UCP message '$str'";

    my %args = (
        o_r => $1,
        ot  => $2,
    );

    if ($args{o_r} eq 'R' and defined $3) {
        $args{ack}  = $3 if $3 eq 'A';
        $args{nack} = $3 if $3 eq 'N';
    };

    return $class->_find_new_class_from_args(\%args);
};


sub new {
    my ($class, %args) = @_;
    return $class->_find_new_class_from_args(\%args)->new(%args);
};


sub new_from_string {
    my ($class, $str) = @_;
    $class->_find_new_class_from_string($str)->new_from_string($str);
};


1;
