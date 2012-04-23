package Protocol::EMIUCP::Message::O_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::O
);
extends qw(Protocol::EMIUCP::Message::Object);

has_field [qw( adc oadc_num ac mt amsg nmsg )];

use constant list_valid_mt_values => [qw( 2 3 )];

use constant list_required_field_names => [qw( adc mt )];

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_hex_to_utf8 from_utf8_to_hex );

my @MT_To_Field;
@MT_To_Field[2, 3] = qw( nmsg amsg );

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[7]
           : $fields->{mt};
    no warnings 'numeric';
    return [ qw( adc oadc ac mt ), $MT_To_Field[$mt||0] || '-msg' ];
};

1;
