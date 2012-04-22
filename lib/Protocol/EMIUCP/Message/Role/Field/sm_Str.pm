package Protocol::EMIUCP::Message::Role::Field::sm_Str;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::Field::Base::Str
    Protocol::EMIUCP::Message::Role
);

has 'sm';

sub _validate_sm {
    my ($self) = @_;
    return $self->_validate_base_Str('sm');
};

1;
