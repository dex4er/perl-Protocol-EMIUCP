package Protocol::EMIUCP::Message::Role::Field::pwd;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::Field::Base::pwd
    Protocol::EMIUCP::Message::Role
);

has field;

my %Methods = (
    _build_args_pwd    => '_build_args_base_pwd',
    _validate_pwd      => '_validate_base_pwd',
    pwd_utf8           => '_base_pwd_utf8',
    _build_hashref_pwd => '_build_hashref_base_pwd',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;
