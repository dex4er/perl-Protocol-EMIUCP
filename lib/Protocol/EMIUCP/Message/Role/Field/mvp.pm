package Protocol::EMIUCP::Message::Role::Field::mvp;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::Field::Base::Str
    Protocol::EMIUCP::Message::Role
);

has 'mvp';

use Carp qw(confess);

sub _validate_mvp {
    my ($self) = @_;
    return $self->_validate_base_Str('mvp');
};

1;
