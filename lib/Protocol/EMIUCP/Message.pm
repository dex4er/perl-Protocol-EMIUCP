package Protocol::EMIUCP::Message;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Exception;

use Mouse::Util qw(load_class);
use Carp qw(confess);

sub import {
    foreach my $field (qw( dcs dst ec lpid mt nt npid onpi opid otoa oton pid rpl styp )) {
        my $class = "Protocol::EMIUCP::Message::Role::Field::$field";
        load_class($class);
        $class->import(caller => caller());
    }
};

sub find_new_class_from_args {
    my ($class, $args) = @_;

    no warnings 'numeric';
    confess "Attribute (o) xor (r) is required"
        unless defined $args->{o} xor defined $args->{r};
    confess "Attribute (ot) is required"
        unless defined $args->{ot};
    confess "Attribute (ot) has invalid value '$args->{ot}', should be between 1 and 99"
        unless $args->{ot} =~ /^\d{1,2}$/;
    confess "Attribute (ack) xor (nack) is required if attribute (r) is true"
        if $args->{r} and not ($args->{ack} xor $args->{nack});

    my $new_class = sprintf 'Protocol::EMIUCP::Message::%s_%02d%s',
        $args->{o} ? 'O' : $args->{r} ? 'R' : 'X',
        $args->{ot},
        $args->{ack} ? '_A' : $args->{nack} ? '_N' : '';

    load_class($new_class);

    return $new_class;
};

sub find_new_class_from_string {
    my ($class, $str) = @_;

    $str =~ m{ ^ (?: \d{2} )? / (?: \d{5} )? / ( [OR] ) / ( \d{2} ) / (?: ( [AN] ) / )? .* / (?: [0-9A-F]{2} )? $ }x
        or Protocol::EMIUCP::Message::Exception->throw(
               message => "Invalid EMI-UCP message", emiucp_string => $str
           );

    my %args = (
        $1 eq 'O' ? (o => $1) : (),
        $1 eq 'R' ? (r => $1) : (),
        ot  => $2,
    );

    if ($args{r} and defined $3) {
        $args{ack}  = $3 if $3 eq 'A';
        $args{nack} = $3 if $3 eq 'N';
    };

    return $class->find_new_class_from_args(\%args);
};

sub parse_string {
    my ($class, $str) = @_;
    return $class->find_new_class_from_string($str)->parse_string($str);
};

# TODO new_message ?
sub new {
    my ($class, %args) = @_;
    return eval { $class->find_new_class_from_args(\%args)->new(%args) }
        || Protocol::EMIUCP::Message::Exception->throw(
               message => 'Cannot create EMI-UCP message',
               %args,
           );
};

sub new_from_string {
    my ($class, $str) = @_;
    return eval { $class->find_new_class_from_string($str)->new_from_string($str) }
        || Protocol::EMIUCP::Message::Exception->throw(
               message => 'Invalid EMI-UCP message',
               emiucp_string => $str,
               eval { %{$class->parse_string($str)} },
           );
};

1;
