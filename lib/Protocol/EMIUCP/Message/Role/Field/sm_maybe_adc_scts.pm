package Protocol::EMIUCP::Message::Role::Field::sm_maybe_adc_scts;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Role::Field::scts;

use Protocol::EMIUCP::Message::Field;

has_field 'sm' => (isa => 'EMIUCP_Str');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

has 'sm_adc' => (
    isa       => 'Maybe[EMIUCP_Num16]',
    is        => 'ro',
    predicate => 'has_sm_adc',
    trigger   => sub {
        $_[0]->{sm} = sprintf '%s:%s', $_[1], $_[0]->{sm_scts}
            if defined $_[1] and defined $_[0]->{sm_scts};
    },
    lazy      => 1,
    default   => sub {
        return unless defined $_[0]->{sm} and $_[0]->{sm} =~ / ^ ( \d{1,16} ) : \d{12} $ /x;
        return $1;
    },
);

has 'sm_scts' => (
    isa       => 'Maybe[EMIUCP_SCTS]',
    is        => 'ro',
    predicate => 'has_sm_scts',
    trigger   => sub {
        $_[0]->{sm} = defined $_[0]->{sm_adc}
            ? sprintf '%s:%s', $_[0]->{sm_adc}, $_[1]
            : $_[1];
    },
    lazy      => 1,
    default   => sub {
       return unless defined $_[0]->{sm} and $_[0]->{sm} =~ / ^ (?: \d{1,16} : )? ( \d{12} ) $ /x;
       return $1;
    },
);

has 'sm_scts_datetime' => (
    isa       => 'Maybe[DateTime]',
    is        => 'ro',
    predicate => 'has_sm_scts_datetime',
    init_arg  => undef,
    HAVE_DATETIME ? (
        lazy      => 1,
        default   => sub {
            my $sm_scts = $_[0]->sm_scts;
            defined $sm_scts ? DateTime::Format::EMIUCP::SCTS->parse_datetime($sm_scts) : undef
        },
    ) : (),
);

1;
