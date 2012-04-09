package Protocol::EMIUCP::Types;

use 5.008;

our $VERSION = '0.01';


use Moose::Util::TypeConstraints;

subtype Nul    => as Str    => where { $_ eq '' };
coerce  Nul    => from Str  => via   { '' };

subtype Int2   => as Str    => where { $_ =~ /^\d{2}$/ };
coerce  Int2   => from Int  => via   { sprintf "%02d", $_ % 1e2 };

subtype Int5   => as Str    => where { $_ =~ /^\d{5}$/ };
coerce  Int5   => from Int  => via   { sprintf "%05d", $_ % 1e5 };

subtype Hex2   => as Str    => where { $_ =~ /^[0-9A-F]{2}$/ };
coerce  Hex2   => from Int  => via   { sprintf "%02X", $_ % 16**2 };

enum    O_R    => [qw( O R )];

enum    ACK    => [qw( A )];
coerce  ACK    => from Bool => via   { $_ ? 'A' : '' };

enum    NACK   => [qw( N )];
coerce  NACK   => from Bool => via   { $_ ? 'N' : '' };

subtype SM     => as Str    => where { $_ =~ /^\d{0,16}:\d{12}$/ };

subtype Num12  => as Str    => where { $_ =~ /^\d{12}$/ };
subtype Num16  => as Str    => where { $_ =~ /^\d{0,16}$/ };
subtype Num160 => as Str    => where { $_ =~ /^\d{0,160}$/ };
subtype Hex640 => as Str    => where { $_ =~ /^[0-9A-F]{0,640}$/ and length($_) % 2 == 0 };

enum    MT23   => [qw( 2 3 )];

use DateTime;
use DateTime::Format::SCTS;

class_type 'DateTime';

subtype SCTS   => as 'Num12';
coerce  SCTS   => from 'DateTime' => via { DateTime::Format::SCTS->format_datetime($_) };
coerce  'DateTime' => from SCTS   => via { DateTime::Format::SCTS->parse_datetime($_) };

require Protocol::EMIUCP::Field::amsg;
coerce 'Protocol::EMIUCP::Field::amsg'
    => from Str
    => via { Protocol::EMIUCP::Field::amsg->new( value => $_ ) };

require Protocol::EMIUCP::Field::sm;
coerce 'Protocol::EMIUCP::Field::sm'
    => from Str
    => via { Protocol::EMIUCP::Field::sm->new( value => $_ ) };

require Protocol::EMIUCP::Field::scts;
coerce 'Protocol::EMIUCP::Field::scts'
    => from Str
    => via { Protocol::EMIUCP::Field::scts->new( value => $_ ) },
    => from 'DateTime'
    => via { Protocol::EMIUCP::Field::scts->new( datetime => $_ ) };


1;
