package Protocol::EMIUCP::Message::Role::Field::pid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role::Field::Base::pid);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(has);

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has field;

my %Methods = (
    import_pid        => '_import_base_pid',
    build_pid_args    => '_build_base_pid_args',
    pid_description   => '_base_pid_description',
    build_pid_hashref => '_build_base_pid_hashref',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

sub validate_pid {
    my ($self) = @_;

    confess "Attribute (pid) is required"
        unless defined $self->{pid};

    return $self
        ->_validate_base_pid(field);
};

1;

