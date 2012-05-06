package Protocol::EMIUCP::Message::Role::Field::npid;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

my $field = do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has_field $field => (isa => 'EMIUCP_Num04', coerce => 1);

with qw(Protocol::EMIUCP::Message::Role::Field::Base::pid);

sub import {
    my ($self, %args) = @_;
    $self->_import_base_pid($field, %args);
};

before BUILD => sub {
    my ($self) = @_;
    $self->_BUILD_base_pid($field);
};

sub npid_description {
    my ($self, $value) = @_;
    return $self->_base_pid_description($field, $value);
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    $self->_make_hashref_base_pid($field, $hashref);
};

1;
