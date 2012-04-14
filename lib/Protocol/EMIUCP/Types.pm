package Protocol::EMIUCP::Types;

use 5.008;

our $VERSION = '0.01';


use Moose::Util::TypeConstraints;

subtype EMIUCP_Nul    => as   Str  => where { $_ eq '' };
coerce  EMIUCP_Nul    => from Str  => via   { '' };

subtype EMIUCP_Num2   => as   Str  => where { $_ =~ /^\d{2}$/ };
coerce  EMIUCP_Num2   => from Int  => via   { sprintf "%02d", $_ % 1e2 };

subtype EMIUCP_Num4   => as   Str  => where { $_ =~ /^\d{4}$/ };
coerce  EMIUCP_Num4   => from Int  => via   { sprintf "%04d", $_ % 1e4 };

subtype EMIUCP_Num5   => as   Str  => where { $_ =~ /^\d{5}$/ };
coerce  EMIUCP_Num5   => from Int  => via   { sprintf "%05d", $_ % 1e5 };

subtype EMIUCP_Hex2   => as   Str  => where { $_ =~ /^[0-9A-F]{2}$/ };
coerce  EMIUCP_Hex2   => from Int  => via   { sprintf "%02X", $_ % 16**2 };

enum    EMIUCP_O      => [qw( O )];
enum    EMIUCP_R      => [qw( R )];
enum    EMIUCP_O_R    => [qw( O R )];

enum    EMIUCP_ACK    => [qw( A )];
coerce  EMIUCP_ACK    => from Bool => via   { $_ ? 'A' : '' };

enum    EMIUCP_NACK   => [qw( N )];
coerce  EMIUCP_NACK   => from Bool => via   { $_ ? 'N' : '' };

subtype EMIUCP_SM     => as   Str  => where { $_ =~ /^\d{0,16}:\d{12}$/ };

subtype EMIUCP_Num12  => as   Str  => where { $_ =~ /^\d{12}$/ };
subtype EMIUCP_Num16  => as   Str  => where { $_ =~ /^\d{0,16}$/ };
subtype EMIUCP_Num160 => as   Str  => where { $_ =~ /^\d{0,160}$/ };
subtype EMIUCP_Hex640 => as   Str  => where { $_ =~ /^[0-9A-F]{0,640}$/ and length($_) % 2 == 0 };

subtype EMIUCP_EC       => as 'EMIUCP_Num2';
subtype EMIUCP_EC_Const => as Str    => where { $_ =~ /^EC_/ };
coerce  EMIUCP_EC
    => from EMIUCP_EC_Const
    => via { Protocol::EMIUCP::Types::ec->$_ };

enum    EMIUCP_MT23   => [qw( 2 3 )];

enum    EMIUCP_PID    => [qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 )];
subtype EMIUCP_PID_Const  => as Str    => where { $_ =~ /^PID_/ };
coerce  EMIUCP_PID
    => from EMIUCP_PID_Const
    => via { Protocol::EMIUCP::Types::pid->$_ };

use MooseX::Types::DateTime;
use DateTime::Format::EMIUCP;

subtype EMIUCP_SCTS       => as 'EMIUCP_Num12';
coerce  EMIUCP_SCTS
    => from 'DateTime'
    => via { DateTime::Format::EMIUCP->format_datetime($_) };
coerce  'DateTime'
    => from EMIUCP_SCTS
    => via { DateTime::Format::EMIUCP->parse_datetime($_) };


1;
