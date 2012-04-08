package Protocol::EMIUCP;

use 5.008;
use YAML::XS;

our $VERSION = '0.01';


BEGIN {
    package Protocol::EMIUCP::Util;

    use constant {
        STX => "\x02",
        ETX => "\x03",
        SEP => '/',
    };

    use Encode;

    our @EXPORT_OK = qw( STX ETX SEP str2hex hex2str );
    our %EXPORT_TAGS = (all => [@EXPORT_OK]);
    sub import {
        goto \&Exporter::import;
    };

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

    $INC{'Protocol/EMIUCP/Util.pm'} = __FILE__;
}


# Factory class

BEGIN {
    package Protocol::EMIUCP;

    use Moose;

    use Protocol::EMIUCP::Util qw(SEP str2hex);

    sub _find_new_class {
        my ($class, %args) = @_;

        no warnings 'numeric';
        confess 'OT is required'  unless defined $args{ot}  and $args{ot} > 0;
        confess 'O_R is required' unless defined $args{o_r} and $args{o_r} =~ /^[OR]$/;
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
        return $new_class;
    };

    sub new_message {
        my ($class, %args) = @_;

        $args{amsg} = str2hex($args{amsg_str})
            if defined $args{amsg_str};

        $class->_find_new_class(%args)->new(%args);
    };

    sub new_message_from_string {
        my ($class, $str) = @_;
        my @fields = split SEP, $str;
        my %args = (
            o_r => $fields[2],
            ot  => $fields[3],
        );
        if ($args{o_r} eq 'R' and defined $fields[4]) {
            $args{ack}  = 'A' if $fields[4] eq 'A';
            $args{nack} = 'N' if $fields[4] eq 'N';
        };

        $class->_find_new_class(%args)->new_from_string($str);
    };
}


BEGIN {
    package Protocol::EMIUCP::Types;

    use Moose::Util::TypeConstraints;

    subtype Int2 => as Str => where { $_ =~ /^\d{2}$/ };
    coerce  Int2 => from Int => via { sprintf "%02d", $_ % 1e2 };

    subtype Int5 => as Str => where { $_ =~ /^\d{5}$/ };
    coerce  Int5 => from Int => via { sprintf "%05d", $_ % 1e5 };

    subtype Hex2 => as Str => where { $_ =~ /^[0-9A-F]{2}$/ };
    coerce  Hex2 => from Int => via { sprintf "%02X", $_ % 16**2 };

    enum O_R => [qw( O R )];

    enum   ACK  => [qw( A )];
    coerce ACK  => from Bool => via { $_ ? 'A' : '' };

    enum   NACK => [qw( N )];
    coerce NACK => from Bool => via { $_ ? 'N' : '' };

    subtype Num16  => as Str => where { $_ =~ /^\d{0,16}$/ };
    subtype Num160 => as Str => where { $_ =~ /^\d{0,160}$/ };
    subtype Hex640 => as Str => where { $_ =~ /^[0-9A-F]{0,640}$/ and length($_) % 2 == 0 };

    enum MT23 => [qw( 2 3 )];
}


# Base class

BEGIN {
    package Protocol::EMIUCP::Message;

    use Moose::Role;

    use Protocol::EMIUCP::Util qw(SEP);

    has trn      => (is => 'ro', isa => 'Int2', coerce => 1, default => 0);
    has len      => (is => 'ro', isa => 'Int5', coerce => 1, writer => '_set_len', predicate => 'has_len');
    has checksum => (is => 'ro', isa => 'Hex2', coerce => 1, writer => '_set_checksum', predicate => 'has_checksum', clearer => '_clear_checksum');

    sub BUILD { };
    after BUILD => sub {
        my ($self) = @_;
        confess sprintf 'LEN mismatch, should be ' . $self->calculate_len
            if $self->has_len and $self->len ne $self->calculate_len;
        confess 'checksum mismatch, should be ' . $self->calculate_checksum
            if $self->has_checksum and $self->checksum ne $self->calculate_checksum;

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
        return sprintf "%05d", length $self->to_string;
    };

    use List::Util 'sum';

    sub calculate_checksum {
        my ($self) = @_;
        my $s = $self->to_string =~ s{[^/]*$}{}r;
        my $c += sum unpack "C*", $s;
        return sprintf "%02X", $c % 16**2;
    };

    requires 'list_data_field_names';

    sub list_field_names {
        my ($self, @fields) = @_;
        my @names = (
            qw( trn len o_r ot ),
            $self->list_data_field_names(@fields),
            qw( checksum )
        );
        return wantarray ? @names : \@names;
    };

    sub parse_fields { };
    around parse_fields => sub {
        my ($orig, $class, @fields) = @_;
        my %args = $class->$orig(@fields);
        @args{$class->list_field_names(@fields)} = @fields;
        return %args;
    };

    sub new_from_string {
        my ($class, $str) = @_;
        my @fields = split SEP, $str;
        my %args = $class->parse_fields(@fields);
        $class->new(%args);
    };

    sub to_string {
        my ($self) = @_;
        join SEP, map { my $field = $self->$_; defined $field ? $field : '' }
            $self->list_field_names;
    };
}


BEGIN {
    package Protocol::EMIUCP::Message::O;

    use Moose::Role;
    with 'Protocol::EMIUCP::Message';

    has o_r      => (is => 'ro', isa => 'O_R', default => 'O', required => 1);
}


BEGIN {
    package Protocol::EMIUCP::Message::R;

    use Moose::Role;
    with 'Protocol::EMIUCP::Message';

    has o_r      => (is => 'ro', isa => 'O_R', default => 'R', required => 1);
}


BEGIN {
    package Protocol::EMIUCP::Message::OT_01;

    use Moose::Role;

    has ot       => (is => 'ro', isa => 'Int2', default => '01', required => 1, coerce => 1);
}


BEGIN {
    package Protocol::EMIUCP::Message::O_01;

    use Moose;

    with 'Protocol::EMIUCP::Message::O';
    with 'Protocol::EMIUCP::Message::OT_01';

    use Protocol::EMIUCP::Util qw(hex2str);

    has adc      => (is => 'ro', isa => 'Num16');
    has oadc     => (is => 'ro', isa => 'Num16');
    has ac       => (is => 'ro', isa => 'Str');
    has mt       => (is => 'ro', isa => 'MT23',   required => 1);
    has nmsg     => (is => 'ro', isa => 'Num160', predicate => 'has_nmsg');
    has amsg     => (is => 'ro', isa => 'Hex640', predicate => 'has_amsg');

    sub BUILD {
        my ($self) = @_;
        confess 'OT != 1' if $self->ot != 1;
        confess 'nmsg for MT=3' if $self->mt == 3 and $self->has_nmsg;
        confess 'amsg for MT=2' if $self->mt == 2 and $self->has_amsg;
    };

    sub list_data_field_names {
        my ($self, @fields) = @_;
        my $mt = (exists $fields[7] ? $fields[7] : $self->mt) || '';
        no warnings 'numeric';
        return qw( adc oadc ac mt ), $mt == 2 ? 'nmsg' : 'amsg';
    };

    sub amsg_to_string {
        my ($self) = @_;
        return hex2str($self->amsg);
    };
}


BEGIN {
    package Protocol::EMIUCP::Message::R_01;

    use Moose::Role;
    with 'Protocol::EMIUCP::Message::R';
    with 'Protocol::EMIUCP::Message::OT_01';

    has sm       => (is => 'ro');
}


BEGIN {
    package Protocol::EMIUCP::Message::R_01_A;

    use Moose;
    with 'Protocol::EMIUCP::Message::R_01';

    has ack      => (is => 'ro', isa => 'ACK', coerce => 1, default => 'A');

    sub list_data_field_names {
        return qw( ack sm )
    };
}


BEGIN {
    package Protocol::EMIUCP::Message::R_01_N;

    use Moose;
    with 'Protocol::EMIUCP::Message::R_01';

    has nack     => (is => 'ro', isa => 'NACK', coerce => 1, default => 'N');
    has ec       => (is => 'ro');

    sub list_data_field_names {
        return qw( nack ec sm );
    };
}


package main;
use YAML::XS;

do {
    my $o_01 = Protocol::EMIUCP->new_message(
        o_r => 'O',
        ot => 1,
        adc => 507998000,
        oadc => 6644,
        mt => 3,
        amsg_from_string => 'TEST',
    );
    print Dump $o_01->to_string, $o_01->amsg_to_string, $o_01;

    my $r_01 = Protocol::EMIUCP->new_message(
        o_r => 'R',
        ot => 1,
        nack => 1,
        ec => $o_01->amsg_to_string,
    );
    print Dump $r_01->to_string, $r_01;
};

do {
    my $o_01 = Protocol::EMIUCP->new_message_from_string(
        '00/00043/O/01/507998000/6644//3/54455354/2E'
    );
    print Dump $o_01->to_string, $o_01->amsg_to_string, $o_01;

    my $r_01 = Protocol::EMIUCP->new_message_from_string(
        '00/00019/R/01/A//68'
    );
    print Dump $r_01->to_string, $r_01;
};
