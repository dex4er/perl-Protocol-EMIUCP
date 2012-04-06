package Protocol::EMIUCP;

use 5.008;

our $VERSION = '0.01';

use MooseX::Declare;

namespace Protocol::EMIUCP;


class Protocol::EMIUCP {
    sub new_message {
        my ($class, %args) = @_;
        confess 'OT is required'  unless $args{ot};
        confess 'O_R is required' unless $args{o_r};
        confess 'ACK or NACK is required if O_R is "R"' if $args{o_r} eq 'R' and not $args{ack} || $args{nack};

        my $new_class = sprintf 'Protocol::EMIUCP::Message::%s_%02d', $args{o_r}, $args{ot};
        if (defined $args{ack}) {
            $new_class .= '_A';
        };
        if (defined $args{nack}) {
            confess 'Both ACK and NACK are defined' if defined $args{ack};
            $new_class .= '_N';
        };

        Class::MOP::load_class($new_class);
        $new_class->new(%args);
    };
};


class ::Types {
    use Moose::Util::TypeConstraints;

    subtype Int2 => as Str => where { $_ =~ /^\d{2}$/ };
    coerce  Int2 => from Int => via { sprintf "%02d", $_ % 1e2 };

    subtype Int5 => as Str => where { $_ =~ /^\d{5}$/ };
    coerce  Int5 => from Int => via { sprintf "%05d", $_ % 1e5 };

    subtype Hex2 => as Str => where { $_ =~ /^[0-9A-F]{2}$/ };
    coerce  Hex2 => from Int => via { sprintf "%02X", $_ % 16**2 };

    enum O_R => [qw( O R )];

    subtype Num16  => as Str => where { $_ =~ /^\d{0,16}$/ };
    subtype Num160 => as Str => where { $_ =~ /^\d{0,160}$/ };
    subtype Hex640 => as Str => where { $_ =~ /^[0-9A-F]{0,640}$/ and length($_) % 2 == 0 };

    enum MT23 => [qw( 2 3 )];
}


class ::Util {
    use Method::Signatures::Simple function_keyword => 'func';

    use constant {
        STX => "\x02",
        ETX => "\x03",
        SEP => '/',
    };

    use Encode;

    # Encode UTF-8 string as ESTI GSM 03.38 hex string
    sub str2hex ($) {
        my ($str) = @_;
        return uc unpack "H*", encode "GSM0338", decode "UTF-8", $str;
    };

    # Decode ESTI GSM 03.38 hex string to UTF-8 string
    sub hex2str ($) {
        my ($hex) = @_;
        return encode "UTF-8", decode "GSM0338", pack "H*", $hex;
    };
}


class ::Message {
    has trn      => (is => 'ro', isa => 'Int2', coerce => 1, default => 0);
    has len      => (is => 'ro', isa => 'Int5', coerce => 1, writer => '_set_len', predicate => 'has_len');
    has o_r      => (is => 'ro', isa => 'O_R',  required => 1);
    has ot       => (is => 'ro', isa => 'Int2', required => 1, coerce => 1);
    has checksum => (is => 'ro', isa => 'Hex2', coerce => 1, writer => '_set_checksum', predicate => 'has_checksum', clearer => '_clear_checksum');

    sub BUILD {
        my ($self) = @_;
        confess 'LEN mismatch' if $self->has_len and $self->len != $self->calculate_len;
        confess 'checksum mismatch' if $self->has_checksum and $self->checksum != $self->calculate_checksum;

        if (not $self->has_len) {
            $self->_set_checksum(0);
            $self->_set_len(0);
            $self->_set_len($self->calculate_len);
            $self->_clear_checksum;
        };

        if (not $self->has_checksum) {
            $self->_set_checksum($self->calculate_checksum);
        };
    };

    sub calculate_len {
        my ($self) = @_;
        return length $self->to_string;
    };

    use List::Util 'sum';

    sub calculate_checksum {
        my ($self) = @_;
        my $s = $self->to_string =~ s{[^/]*$}{}r;
        my $c += sum unpack "C*", $s;
        return sprintf "%02X", $c % 16**2;
    };

    sub data_fields {
        confess 'abstract method';
    };

    sub to_string {
        my ($self) = @_;
        join Protocol::EMIUCP::Util::SEP,
             map { my $field = $self->$_; defined $field ? $field : '' }
                qw( trn len o_r ot ), @{$self->data_fields}, qw( checksum );
    };
}


class ::Message::O_01 extends ::Message {
    has '+ot'    => (default => 1);
    has '+o_r'   => (default => 'O');
    has adc      => (is => 'ro', isa => 'Num16');
    has oadc     => (is => 'ro', isa => 'Num16');
    has ac       => (is => 'ro', isa => 'Str');
    has mt       => (is => 'ro', isa => 'MT23',   required => 1);
    has nmsg     => (is => 'ro', isa => 'Num160', predicate => 'has_nmsg');
    has amsg     => (is => 'ro', isa => 'Str', predicate => 'has_amsg', reader => '_get_amsg', trigger => \&_trigger_amsg);
    has amsg_hex => (is => 'ro', isa => 'Hex640', reader => '_get_amsg_hex', writer => '_set_amsg_hex');

    sub BUILD {
        my ($self) = @_;
        confess 'OT != 1' if $self->ot != 1;
        confess 'nmsg for MT=3' if $self->mt == 3 and $self->has_nmsg;
        confess 'amsg for MT=2' if $self->mt == 2 and $self->has_amsg;
    };

    sub data_fields {
        my ($self) = @_;
        [ qw( adc oadc ac mt ), $self->mt == 2 ? 'nmsg' : 'amsg' ]
    };

    sub _trigger_amsg {
        my ($self, $str) = @_;
        return $self->_set_amsg_hex(Protocol::EMIUCP::Util::str2hex($str));
    };

    sub amsg {
        my ($self) = @_;
        return Protocol::EMIUCP::Util::hex2str($self->_get_amsg_hex);
    };
}


class ::Message::R_01 extends ::Message {
    has sm       => (is => 'ro');
}


class ::Message::R_01_A extends ::Message::R_01 {
    has ack      => (is => 'ro');

    sub data_fields {
        [ qw( ack sm ) ]
    };
}


class ::Message::R_01_N extends ::Message::R_01 {
    has nack     => (is => 'ro');
    has ec       => (is => 'ro');

    sub data_fields {
        [ qw( ack ec sm ) ]
    };
}


package main;

my $o_01 = Protocol::EMIUCP->new_message(
    o_r => 'O',
    ot => 1,
    adc => 507998000,
    oadc => 6644,
    mt => 3,
    amsg => 'TEST',
);
use YAML::XS;
print Dump $o_01->to_string, $o_01->amsg, $o_01;
