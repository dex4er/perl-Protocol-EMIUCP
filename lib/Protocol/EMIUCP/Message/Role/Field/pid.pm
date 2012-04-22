package Protocol::EMIUCP::Message::Role::Field::pid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::Field::Base::pid
    Protocol::EMIUCP::Message::Role
);

has field;

use Carp qw(confess);

my %Methods = (
    _import_pid        => '_import_base_pid',
    _build_args_pid    => '_build_args_base_pid',
    pid_description    => '_base_pid_description',
    _build_hashref_pid => '_build_hashref_base_pid',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;
