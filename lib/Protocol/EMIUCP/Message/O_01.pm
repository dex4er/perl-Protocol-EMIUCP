package Protocol::EMIUCP::Message::O_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::Base';

use Carp qw(confess);
use Scalar::Util qw(looks_like_number);
use Protocol::EMIUCP::Util qw( from_hex_to_utf8 from_utf8_to_hex );

sub new {
    my ($class, %args) = @_;

    confess "Attribute (mt) is required"
        if not defined $args{mt};
    confess "Attribute (mt) is invalid, should be a number"
        if not looks_like_number $args{mt};
    confess "Attribute (nmsg) is invalid, should be undefined if mt == 3"
        if $args{mt} == 3 and defined $args{nmsg};
    confess "Attribute (nmsg) is invalid, should be a number"
        if $args{mt} == 3 and defined $args{nmsg} and not looks_like_number $args{nmsg};
    confess "Attribute (amsg) is invalid, should be undefined if mt == 2"
        if $args{mt} == 2 and defined $args{amsg};

    $args{amsg} = from_utf8_to_hex $args{amsg_utf8} if defined $args{amsg_utf8};

    return $class->SUPER::new(%args);
};

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[7]
           : $fields->{mt};
    $mt = 0 if not looks_like_number $mt;
    my @fields = ( qw( adc oadc ac mt ), ( $mt == 2 ? 'nmsg' : 'amsg' ) );
    return wantarray ? @fields : \@fields;
};

sub amsg_utf8 {
    my ($self) = @_;
    return from_hex_to_utf8 $self->{amsg}
};

sub as_hashref {
    my ($self) = @_;
    return {
        %{ $self->SUPER::as_hashref },
        defined $self->{amsg} ? (amsg_utf8 => $self->amsg_utf8) : (),
    };
};

1;
