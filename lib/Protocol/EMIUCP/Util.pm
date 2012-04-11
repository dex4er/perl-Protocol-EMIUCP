package Protocol::EMIUCP::Util;

use 5.008;

our $VERSION = '0.01';


use Exporter ();
our @EXPORT_OK = qw( STX ETX SEP encode_hex decode_hex );
our %EXPORT_TAGS = (all => [@EXPORT_OK]);
*import = \&Exporter::import;


use constant {
    STX => "\x02",
    ETX => "\x03",
    SEP => '/',
};


use Encode;

# Encode UTF-8 string as ESTI GSM 03.38 hex string
sub encode_hex ($) {
    my ($str) = @_;
    return uc unpack "H*", encode "GSM0338", decode "UTF-8", $str;
};


# Decode ESTI GSM 03.38 hex string to UTF-8 string
sub decode_hex ($) {
    my ($hex) = @_;
    return encode "UTF-8", decode "GSM0338", pack "H*", $hex;
};


1;
