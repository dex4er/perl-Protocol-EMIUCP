package Protocol::EMIUCP::Field;

use strict;
use warnings;

use 5.006;

our $VERSION = '0.01';

use Exporter ();
our @EXPORT = qw( has_field with_field );
*import = \&Exporter::import;


my %fields = (

    ac       => {
        is        => 'ro',
        isa       => 'Str',
    },

    ack      => {
        is        => 'ro',
        isa       => 'EMIUCP_ACK',
        coerce    => 1,
        required  => 1,
        default   => 'A',
    },

    adc      => {
        is        => 'ro',
        isa       => 'EMIUCP_Num16',
        required  => 1,
    },

    amsg     => {
        is        => 'ro',
        isa       => 'Protocol::EMIUCP::Types::amsg',
        coerce    => 1,
        predicate => 'has_amsg',
        handles   => {
            amsg_string => 'as_string',
            amsg_utf8   => 'utf8',
        },
    },

    checksum => {
        is        => 'ro',
        isa       => 'EMIUCP_Hex2',
        coerce    => 1,
        writer    => '_set_checksum',
        predicate => 'has_checksum',
        clearer   => '_clear_checksum',
    },

    ec       => {
        is        => 'ro',
        isa       => 'Protocol::EMIUCP::Types::ec',
        coerce    => 1,
        required  => 1,
        handles   => {
            ec_string  => 'as_string',
            ec_number  => 'as_number',
            ec_message => 'as_message',
        },
    },

    len      => {
        is        => 'ro',
        isa       => 'EMIUCP_Num5',
        coerce    => 1,
        writer    => '_set_len',
        predicate => 'has_len',
    },

    mt       => {
        is        => 'ro',
        isa       => 'EMIUCP_MT23',
        required  => 1,
    },

    nack     => {
        is        => 'ro',
        isa       => 'EMIUCP_NACK',
        coerce    => 1,
        required  => 1,
        default   => 'N',
    },

    nmsg     => {
        is        => 'ro',
        isa       => 'EMIUCP_Num160',
        predicate => 'has_nmsg',
    },

    o_r      => {
        is        => 'ro',
        isa       => 'EMIUCP_O_R',
        required  => 1
    },

    oadc     => {
        is        => 'ro',
        isa       => 'EMIUCP_Num16',
    },

    ot       => {
        is        => 'ro',
        isa       => 'EMIUCP_Num2',
        coerce    => 1,
        required  => 1,
    },

    pid      => {
        is        => 'ro',
        isa       => 'Protocol::EMIUCP::Types::pid',
        coerce    => 1,
        required  => 1,
        handles   => {
            pid_as_string => 'value',
            pid_message   => 'as_message',
        },
    },

    trn      => {
        is        => 'ro',
        isa       => 'EMIUCP_Num2',
        coerce    => 1,
        default   => '00',
    },

);


use Carp qw(confess);
use Protocol::EMIUCP::Types;

sub has_field ($;%) {
    my ($name, %props) = @_;

    my $class = delete $props{class} || caller();
    confess "Class ($class) missing method (meta)" unless $class->can('meta');

    if (ref $name and ref $name eq 'ARRAY') {
        $class->meta->add_attribute(
            $_ => %{ $fields{$_} }, %props
        ) foreach @$name;
    }
    else {
        $class->meta->add_attribute(
            $name => %{ $fields{$name} }, %props
        );
    };
};


use Moose::Util ();

sub with_field ($;%) {
    my ($name, %props) = @_;

    my $role_name = delete $props{role};
    my $class = caller();

    if (ref $name and ref $name eq 'ARRAY') {
        foreach (@$name) {
            my $role = __PACKAGE__ . '::' . $_;
            Moose::Util::apply_all_roles($class, $role);
        };
    }
    else {
        my $role = __PACKAGE__ . '::' . ($role_name || $name);
        Moose::Util::apply_all_roles($class, $role);
    };
    has_field($name, %props, class => $class) if defined $fields{$name};
};


1;
