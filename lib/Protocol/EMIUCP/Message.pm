package Protocol::EMIUCP::Message;

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Exception;

use Mouse::Util qw(load_class);

sub import {
    foreach my $field (qw( dcs dst ec lpid mt nt npid onpi opid otoa oton pid rpl styp )) {
        my $class = "Protocol::EMIUCP::Message::Role::Field::$field";
        load_class($class);
        $class->import(caller => caller);
    }
};

sub _find_new_class_from_args {
    my ($class, $args) = @_;

    no warnings 'numeric';
    confess "Attribute (ot) is required"
        unless defined $args->{ot};
    confess "Attribute (ot) has invalid value '$args->{ot}', should be between 1 and 99"
        unless $args->{ot} =~ /^\d{1,2}$/;
    confess "Attribute (o_r) is required"
        unless defined $args->{o_r};
    confess "Attribute (o_r) has invalid value '$args->{o_r}', should be 'O' or 'R'"
        unless $args->{o_r} eq 'O' or $args->{o_r} eq 'R';
    confess "Attribute (ack) xor (nack) is required if attribute (o_r) eq 'R'"
        if $args->{o_r} eq 'R' and not ($args->{ack} xor $args->{nack});

    my $new_class = sprintf 'Protocol::EMIUCP::Message::%s_%02d', $args->{o_r}, $args->{ot};
    $new_class .= '_A' if $args->{ack};
    $new_class .= '_N' if $args->{nack};

    load_class($new_class);

    return $new_class;
};

sub _parse_args_from_string {
    my ($class, $str) = @_;

    $str =~ m{ ^ \d{2} / \d{5} / ( [OR] ) / ( \d{2} ) / (?: ( [AN] ) / )? .* / [0-9A-F]{2} $ }x
        or Protocol::EMIUCP::Message::Exception->throw(
               message => "Invalid EMI-UCP message", emiucp_string => $str
           );

    my %args = (
        o_r => $1,
        ot  => $2,
    );

    if ($args{o_r} eq 'R' and defined $3) {
        $args{ack}  = $3 if $3 eq 'A';
        $args{nack} = $3 if $3 eq 'N';
    };

    return \%args;
};

# TODO BUILDARGS
sub new {
    my ($class, %args) = @_;
    return eval { $class->_find_new_class_from_args(\%args)->new(%args) }
        || Protocol::EMIUCP::Message::Exception->throw(
               message => 'Cannot create EMI-UCP message'
           );
};

sub new_from_string {
    my ($class, $str) = @_;
    my $args = $class->_parse_args_from_string($str);
    return eval { $class->_find_new_class_from_args($args)->new_from_string($str) }
        || Protocol::EMIUCP::Message::Exception->throw(
               message => 'Invalid EMI-UCP message', emiucp_string => $str
           );
};

1;
