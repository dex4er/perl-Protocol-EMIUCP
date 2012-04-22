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

has [qw( adc ac nrq lrq lrad dd pr cpg rply hplmn res4 res5 )];
has_field [qw(
    oadc_alphanum nadc nt npid lpid ddt vp rpid scts dst rsn dscts mt nmsg
    amsg tmsg mms dcs mcls rpl otoa xser
)];

use constant list_valid_mt_values => [ qw( 2 3 4 )];

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

sub build_args_o_50 {
    my ($class, $args) = @_;

    foreach my $name (qw( nrq lrq dd )) {
        $args->{$name}  = 0
            if exists $args->{$name} and not $args->{$name};
    };

    return $class;
};

sub validate_o_50 {
    my ($self) = @_;

    foreach my $name (qw( adc nadc lrad hplmn )) {
        confess "Attribute ($name) is invalid"
            if defined $self->{$name} and not $self->{$name}  =~ /^\d{1,16}$/;
    };
    foreach my $name (qw( nrq lrq dd )) {
        confess "Attribute ($name) is invalid"
            if defined $self->{$name} and not $self->{$name}  =~ /^[01]$/;
    };
    confess "Attribute (ac) is invalid"
        if defined $self->{ac}   and not $self->{ac}   =~ /^\d{4,16}$/;
    confess "Attribute (pr) is invalid"
        if defined $self->{pr}   and not $self->{pr} =~ /^.$/;
    confess "Attribute (cpg) is invalid"
        if defined $self->{cpg}  and not $self->{cpg} =~ /^\d$/;
    confess "Attribute (rply) is invalid"
        if defined $self->{rply} and not $self->{rply} =~ /^\d$/;

    return $self;
};

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
