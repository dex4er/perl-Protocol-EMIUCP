package Protocol::EMIUCP::Util;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

use Exporter ();
our @EXPORT_OK = qw(
    ETX STX
    decode_7bit_hex encode_7bit_hex
    decode_hex encode_hex
    from_hex_to_utf8 from_utf8_to_hex
    from_7bit_hex_to_utf8 from_utf8_to_7bit_hex
    load_class has
);
our %EXPORT_TAGS = (all => [@EXPORT_OK]);
BEGIN { *import = \&Exporter::import; }


use constant {
    STX => "\x02",
    ETX => "\x03",
};


sub load_class ($) {
    my ($class) = @_;
    (my $file = $class . '.pm') =~ s{::}{/}g;
    eval {
        require $file;
    };
    confess $@ if $@;
};

sub has ($) {
    my ($class, $attrs) = @_;
    my $caller = caller();
    no strict 'refs';
    foreach my $name (@$attrs) {
        *{"${caller}::$name"}     = sub { $_[0]->{$name} };
        *{"${caller}::has_$name"} = sub { exists $_[0]->{$name} };
    };
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
    $len -= $len > 6 ? int($len / 8) : 0;

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
    return pack 'b*', $bits;
};

# Convert between UTF-8 and GSM 03.38 hex string
sub from_utf8_to_hex ($) {
    my ($str) = @_;
    return uc unpack "H*", encode "GSM0338", decode "UTF-8", $str;
};

# Convert between GSM 03.38 hex string and UTF-8
sub from_hex_to_utf8 ($) {
    my ($hex) = @_;
    return encode "UTF-8", decode "GSM0338", pack "H*", $hex
};

# Convert between UTF-8 and GSM 03.38 7-bit hex string
sub from_utf8_to_7bit_hex ($) {
    my ($str) = @_;
    return encode_7bit_hex encode "GSM0338", decode "UTF-8", $str;
};

# Convert between GSM 03.38 7-bit hex string and UTF-8
sub from_7bit_hex_to_utf8 ($) {
    my ($hex) = @_;
    return encode "UTF-8", decode "GSM0338", decode_7bit_hex $hex
};

1;
