package Protocol::EMIUCP::Util;

use 5.008;

our $VERSION = '0.01';


use Exporter ();
our @EXPORT_OK = qw( STX ETX SEP encode_hex decode_hex has_field );
our %EXPORT_TAGS = (all => [@EXPORT_OK]);
sub import {
    goto \&Exporter::import;
};


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


use Protocol::EMIUCP::Field;

sub has_field ($;@) {
    my ($name, @props) = @_;
    if (ref $name and ref $name eq 'ARRAY') {
        caller()->meta->add_attribute(
            $_ => %{ Protocol::EMIUCP::Field::fields->{$_} }, @props
        ) foreach @$name;
    }
    else {
        caller()->meta->add_attribute(
            $name => %{ Protocol::EMIUCP::Field::fields->{$name} }, @props
        );
    };
};


1;
