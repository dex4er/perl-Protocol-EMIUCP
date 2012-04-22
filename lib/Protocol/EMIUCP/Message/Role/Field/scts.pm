package Protocol::EMIUCP::Message::Role::Field::scts;

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

use Carp qw(confess);

eval { require DateTime::Format::EMIUCP::SCTS };

my %Methods = (
    _import_scts        => '_import_base_scts',
    _build_args_scts    => '_build_args_base_scts',
    _validate_scts      => '_validate_base_scts',
    scts_datetime       => '_base_scts_datetime',
    _build_hashref_scts => '_build_hashref_base_scts',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;
