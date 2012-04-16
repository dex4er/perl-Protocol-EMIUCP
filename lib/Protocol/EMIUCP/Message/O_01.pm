package Protocol::EMIUCP::Message::O_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Base::O);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_hex_to_utf8 from_utf8_to_hex );

__PACKAGE__->make_accessors( [qw( adc oadc ac mt nmsg amsg )] );

sub build_args {
    my ($class, $args) = @_;

    confess "Attribute (mt) is required"
        if not defined $args->{mt};

    {
        no warnings 'numeric';
        confess "Attribute (nmsg) is invalid, should be undefined if mt == 3"
            if $args->{mt} == 3 and defined $args->{nmsg};
        confess "Attribute (amsg) is invalid, should be undefined if mt == 2"
            if $args->{mt} == 2 and defined $args->{amsg};
    }

    $args->{ot} = '01' unless defined $args->{ot};

    $args->{amsg} = from_utf8_to_hex $args->{amsg_utf8}
        if defined $args->{amsg_utf8};

    return $class;
};

sub validate {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '01'"
        if defined $self->{ot}   and $self->{ot} ne '01';
    confess "Attribute (adc) is invalid"
        if defined $self->{adc}  and not $self->{adc}  =~ /^\d{1,16}$/;
    confess "Attribute (oadc) is invalid"
        if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}$/;
    confess "Attribute (ac) is invalid"
        if defined $self->{ac}   and not $self->{ac}   =~ /^\d{4,16}$/;
    confess "Attribute (mt) is invalid"
        if defined $self->{mt}   and not $self->{mt}   =~ /^[23]$/;
    confess "Attribute (nmsg) is invalid"
        if defined $self->{nmsg} and not $self->{nmsg} =~ /^\d{1,160}$/;
    confess "Attribute (amsg) is invalid"
        if defined $self->{amsg} and not $self->{amsg} =~ /^[\dA-F]{2,640}$/;

    return $self;
};

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[7]
           : $fields->{mt};
    no warnings 'numeric';
    return +( qw( adc oadc ac mt ), ( $mt == 2 ? 'nmsg' : 'amsg' ) );
};

sub amsg_utf8 {
    my ($self) = @_;
    return from_hex_to_utf8 $self->{amsg}
};

sub build_hashref {
    my ($self, $hashref) = @_;
    $hashref->{amsg_utf8} = $self->amsg_utf8 if defined $hashref->{amsg};
    return $self;
};

1;
