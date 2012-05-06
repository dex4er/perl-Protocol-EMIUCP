package Protocol::EMIUCP::Util;

use strict;
use warnings;

our $VERSION = '0.01';

use Exporter qw(import);
our %EXPORT_TAGS = (all => [qw(
    ETX STX
)]);
our @EXPORT_OK = $EXPORT_TAGS{all};

use constant {
    STX => "\x02",
    ETX => "\x03",
};

1;
