package Protocol::EMIUCP::Util;

use 5.006;

our $VERSION = '0.01';


use Exporter ();
our @EXPORT_OK = qw( ETX SEP STX decode_7bit_hex encode_7bit_hex decode_gsm encode_gsm decode_hex encode_hex decode_utf8 encode_utf8 );
our %EXPORT_TAGS = (all => [@EXPORT_OK]);
*import = \&Exporter::import;


use constant {
    STX => "\x02",
    ETX => "\x03",
    SEP => '/',
};


use Encode qw( decode encode );

# Encode as ESTI GSM 03.38 hex string
sub encode_hex ($) {
    my ($str) = @_;
    return uc unpack "H*", $str;
};

# Decode from ESTI GSM 03.38 hex string
sub decode_hex ($) {
    my ($hex) = @_;
    return pack "H*", $hex;
};

# Encode as ESTI GSM 03.38 7-bit hex string
sub encode_7bit_hex {
    my ($str) = @_;

    my $len = length($str)*2;
    $len -= $l > 6 ? int($l / 8) : 0;

    my $bits = unpack 'b*', $str;
    $bits =~ s/(.{7})./$1/g;

    return sprintf '%02X%s', $len, uc unpack 'H*', pack 'b*', $bits;
};

# Decode from ESTI GSM 03.38 7-bit hex string
sub decode_7bit_hex {
    my ($str) = @_;
    $str =~ s/^(..)//;

    my $len = (hex($1)+2)*4;
    my $bits = unpack "b*", pack "H*", $str;
    $bits =~ s/(.{7})/$1./g;
    $bits = substr $bits, 0, $len;
    $bits = substr $bits, 0, int(length($bits) / 8) * 8;
    return pack 'b*', $b;
};

# Encode as strict UTF-8
sub encode_utf8 ($) {
    my ($str) = @_;
    return encode "UTF-8", $str;
};

# Decode from strict UTF-8
sub decode_utf8 ($) {
    my ($str) = @_;
    return decode "UTF-8", $str;
};

# Encode as GSM 03.38
sub encode_gsm ($) {
    my ($str) = @_;
    return encode "GSM0338", $str;
};

# Decode from GSM 03.38
sub decode_gsm ($) {
    my ($str) = @_;
    return decode "GSM0338", $str;
};


1;
