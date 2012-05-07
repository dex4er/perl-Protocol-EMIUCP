package Protocol::EMIUCP::Message::Types;

use Moose::Util::TypeConstraints;

our $VERSION = '0.01';

subtype 'EMIUCP_Nul'     => as   'Str'  => where { $_ eq '' };

subtype 'EMIUCP_Str'     => as   'Str'  => where { not y{/}{} };

subtype 'EMIUCP_Bool'    => as   'Str'  => where { /^[01]?$/ };

subtype 'EMIUCP_Num1'    => as   'Str'  => where { /^\d$/ };
subtype 'EMIUCP_Num4'    => as   'Str'  => where { /^\d{1,4}$/ };
subtype 'EMIUCP_Num16'   => as   'Str'  => where { /^\d{1,16}$/ };
subtype 'EMIUCP_Num4_16' => as   'Str'  => where { /^\d{4,16}$/ };
subtype 'EMIUCP_Num160'  => as   'Str'  => where { /^\d{1,160}$/ };

subtype 'EMIUCP_Num_10'  => as   'Str'  => where { /^\d{10}$/ };
subtype 'EMIUCP_Num_12'  => as   'Str'  => where { /^\d{12}$/ };

subtype 'EMIUCP_Num02'   => as   'Str'  => where { /^\d{2}$/ };
coerce  'EMIUCP_Num02'   => from 'Int'  => via   { sprintf "%02d", $_ };

subtype 'EMIUCP_Num03'   => as   'Str'  => where { /^\d{3}$/ };
coerce  'EMIUCP_Num03'   => from 'Int'  => via   { sprintf "%03d", $_ };

subtype 'EMIUCP_Num04'   => as   'Str'  => where { /^\d{4}$/ };
coerce  'EMIUCP_Num04'   => from 'Int'  => via   { sprintf "%04d", $_ };

subtype 'EMIUCP_Num05'   => as   'Str'  => where { /^\d{5}$/ };
coerce  'EMIUCP_Num05'   => from 'Int'  => via   { sprintf "%05d", $_ };

subtype 'EMIUCP_Hex02'   => as   'Str'  => where { /^[\dA-F]{2}$/ };
subtype 'EMIUCP_Hex16'   => as   'Str'  => where { /^[\dA-F]{2,16}$/ and length($_) % 2 == 0 };
subtype 'EMIUCP_Hex22'   => as   'Str'  => where { /^[\dA-F]{2,22}$/ and length($_) % 2 == 0 };

subtype 'EMIUCP_Hex400'  => as   'Str'  => where { /^[\dA-F]{2,400}$/ and length($_) % 2 == 0 };
subtype 'EMIUCP_Hex640'  => as   'Str'  => where { /^[\dA-F]{2,640}$/ and length($_) % 2 == 0 };
subtype 'EMIUCP_Hex1403' => as   'Str'  => where { /^[\dA-F]{2,1403}$/ };

1;
