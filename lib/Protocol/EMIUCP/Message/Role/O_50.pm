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

has [qw( adc ac nrq nadc lrq lrad lpid dd pr cpg rply hplmn )];
has_field [qw(
    oadc_alphanum nt npid lpid ddt vp scts dst dscts mt nmsg amsg tmsg mms dcs
    mcls rpl otoa xser
)];

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

use constant list_valid_rpid_values => [
    map { sprintf '%04d', $_ } 0..71, 95, 127, 192..255
];

use constant list_valid_rsn_values => [
    map { sprintf '%03d', $_ } 0..255
];

use constant list_valid_mt_values => [ qw( 2 3 4 )];

sub build_args_o_50 {
    my ($class, $args) = @_;

    foreach my $name (qw( nrq lrq dd )) {
        $args->{$name}  = 0
            if exists $args->{$name} and not $args->{$name};
    };

    $args->{nb} = 4 * length $args->{tmsg}  # one char from tmsg is 4 bits
        if not defined $args->{nb} and defined $args->{tmsg};

    $args->{rpid} = sprintf '%04d', $args->{rpid}
        if defined $args->{rpid} and $args->{rpid} =~ /^\d+$/;
    $args->{rsn} = sprintf '%03d', $args->{rsn}
        if defined $args->{rsn} and $args->{rsn} =~ /^\d+$/;

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
    confess "Attribute (rpid) is invalid"
        if defined $self->{rpid} and not grep { $_ eq $self->{rpid} } @{ $self->list_valid_rpid_values };
    confess "Attribute (rsn) is invalid"
        if defined $self->{rsn}  and not grep { $_ eq $self->{rsn} } @{ $self->list_valid_rsn_values };
    confess "Attribute (nb) is invalid"
        if defined $self->{nb}   and not $self->{nb} =~ /^\d{1,4}$/;
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
        qw( mms pr dcs mcls rpl cpg rply otoa hplmn xser ),
    ];
};

1;
