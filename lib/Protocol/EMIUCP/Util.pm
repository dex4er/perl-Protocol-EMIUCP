package Protocol::EMIUCP::Util;

use 5.006;

our $VERSION = '0.01';


use Exporter ();
our @EXPORT_OK = qw( ETX SEP STX decode_gsm encode_gsm decode_hex encode_hex decode_utf8 encode_utf8 );
our %EXPORT_TAGS = (all => [@EXPORT_OK]);
*import = \&Exporter::import;


use constant {
    STX => "\x02",
    ETX => "\x03",
    SEP => '/',
};


use Encode qw( decode encode );

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


1;
