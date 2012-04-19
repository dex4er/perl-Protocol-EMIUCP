package Protocol::EMIUCP::Message::Role::Field::lpid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role::Field::Base::pid);

use Protocol::EMIUCP::Util qw(has);

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has field;

my %Methods = (
    import_lpid        => '_import_base_pid',
    build_lpid_args    => '_build_base_pid_args',
    validate_lpid      => '_validate_base_pid',
    lpid_description   => '_base_pid_description',
    build_lpid_hashref => '_build_base_pid_hashref',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;

