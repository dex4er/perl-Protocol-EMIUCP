package Protocol::EMIUCP::Message::Role::Field::npid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role::Field::Base::pid);

my %Methods = (
    import_npid        => '_import_base_pid',
    build_npid_args    => '_build_base_pid_args',
    validate_npid      => '_validate_base_pid',
    npid_description   => '_base_pid_description',
    build_npid_hashref => '_build_base_pid_hashref',
);

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;

