package Protocol::EMIUCP::Message::Role::O_5x;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

with_field [qw(
    adc oadc_alphanum ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid scts
    dst rsn dscts mt nb nmsg amsg tmsg mms pr dcs mcls rpl cpg rply otoa hplmn
    xser
)];
has_field [qw( res4 res5 )] => (isa => 'EMIUCP_Nul');

my @MT_To_Field;
@MT_To_Field[2, 3, 4] = qw( nmsg amsg tmsg );

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[22]
           : $fields->{mt};
    no warnings 'numeric';
    return [
        qw(
            adc oadc ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid scts dst
            rsn dscts mt nb
        ),
        $MT_To_Field[$mt||0] || '-msg',
        qw(
            mms pr dcs mcls rpl cpg rply otoa hplmn xser res4 res5
        ),
    ];
};

1;
