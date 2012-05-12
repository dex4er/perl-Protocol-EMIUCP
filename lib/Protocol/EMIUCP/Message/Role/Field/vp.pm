package Protocol::EMIUCP::Message::Role::Field::vp;

use Mouse::Role;

use Mouse::Util::TypeConstraints;

subtype 'EMIUCP_VP' => as 'EMIUCP_Num_10';

class_type 'DateTime';

coerce  'EMIUCP_VP'
    => from 'DateTime'
    => via { DateTime::Format::EMIUCP::VP->format_datetime($_) };

use Protocol::EMIUCP::Message::Field;

has_field 'vp' => (isa => 'EMIUCP_Num_10');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::VP };

has 'vp_datetime' => (
    isa       => 'Maybe[DateTime]',
    is        => 'ro',
    predicate => 'has_vp_datetime',
    init_arg  => undef,
    HAVE_DATETIME ? (
        lazy      => 1,
        default   => sub {
            defined $_[0]->{vp} ? DateTime::Format::EMIUCP::VP->parse_datetime($_[0]->{vp}) : undef
        },
    ) : (),
);

1;
