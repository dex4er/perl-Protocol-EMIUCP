package Protocol::EMIUCP::Message::Role::Field::dscts;

use Moose::Role;

use Moose::Util::TypeConstraints;

subtype 'EMIUCP_DSCTS' => as 'EMIUCP_Num_12';

class_type 'DateTime';

coerce  'EMIUCP_DSCTS'
    => from 'DateTime'
    => via { DateTime::Format::EMIUCP::DSCTS->format_datetime($_) };

use Protocol::EMIUCP::Message::Field;

has_field 'dscts' => (isa => 'EMIUCP_Num_12');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::DSCTS };

has 'dscts_datetime' => (
    isa       => 'Maybe[DateTime]',
    is        => 'ro',
    predicate => 'has_dscts_datetime',
    init_arg  => undef,
    HAVE_DATETIME ? (
        lazy      => 1,
        default   => sub {
            defined $_[0]->{dscts} ? DateTime::Format::EMIUCP::DSCTS->parse_datetime($_[0]->{dscts}) : undef
        },
    ) : (),
);

1;
