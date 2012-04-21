package Protocol::EMIUCP::Message::Role::Field::dscts;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::Field::Base::scts
    Protocol::EMIUCP::Message::Role
);

has field;

eval { require DateTime::Format::EMIUCP::DSCTS };

my %Methods = (
    import_dscts        => '_import_base_scts',
    build_args_dscts    => '_build_base_scts_args',
    validate_dscts      => '_validate_base_scts',
    dscts_datetime      => '_base_scts_datetime',
    build_hashref_dscts => '_build_base_scts_hashref',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;
