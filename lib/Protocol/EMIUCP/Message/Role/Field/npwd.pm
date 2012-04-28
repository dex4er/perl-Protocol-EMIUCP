package Protocol::EMIUCP::Message::Role::Field::npwd;

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
    _build_args_npwd    => '_build_args_base_pwd',
    _validate_npwd      => '_validate_base_pwd',
    npwd_utf8           => '_base_npwd_utf8',
    _build_hashref_npwd => '_build_hashref_base_pwd',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;
