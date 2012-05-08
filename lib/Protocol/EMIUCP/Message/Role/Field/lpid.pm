package Protocol::EMIUCP::Message::Role::Field::lpid;

use Moose::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::Field::Base::pid);

use Protocol::EMIUCP::Message::Field;

my $field = do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has_field $field => (isa => 'EMIUCP_PID');

sub import {
    my ($self, %args) = @_;
    $self->_import_base_pid($field, %args);
};

sub lpid_description {
    my ($self, $value) = @_;
    return $self->_base_pid_description($field, $value);
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    $self->_make_hashref_base_pid($field, $hashref);
};

1;
