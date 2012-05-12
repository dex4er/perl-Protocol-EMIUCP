package Protocol::EMIUCP::Message::Role::Field::lpid;

use Moose::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::Field::Base::pid);

use Protocol::EMIUCP::Message::Field;

my $field = do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has_field $field => (isa => 'EMIUCP_PID');

has "${field}_description" => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => "has_${field}_description",
    init_arg  => undef,
    lazy      => 1,
    default   => sub { defined $_[0]->{$field} ? $_[0]->_base_pid_description($field) : undef },
);

sub import {
    my ($self, %args) = @_;
    $self->_import_base_pid($field, %args);
};

1;
