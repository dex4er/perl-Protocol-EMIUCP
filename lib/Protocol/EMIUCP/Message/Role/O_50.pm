package Protocol::EMIUCP::Message::Role::O_50;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::O
    Protocol::EMIUCP::Message::Role::OT_50
);

has [qw( res4 res5 )];
has_field [qw(
    adc oadc_alphanum ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid scts
    dst rsn dscts mt nmsg amsg tmsg mms pr dcs mcls rpl cpg rply otoa hplmn
    xser
)];

use constant list_valid_mt_values => [ qw( 2 3 4 ) ];

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

my @MT_To_Field;
@MT_To_Field[2, 3, 4] = qw( nmsg amsg tmsg );

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[22]
           : $fields->{mt};
    no warnings 'numeric';
    return [
        qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid scts dst rsn dscts mt nb ),
        $MT_To_Field[$mt||0] || '-msg',
        qw( mms pr dcs mcls rpl cpg rply otoa hplmn xser res4 res5 ),
    ];
};

1;
