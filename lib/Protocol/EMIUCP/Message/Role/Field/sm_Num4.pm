package Protocol::EMIUCP::Message::Role::Field::sm_Num4;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::Field::Base::Num4
    Protocol::EMIUCP::Message::Role
);

has 'sm';

sub _validate_sm_Num4 {
    my ($self) = @_;
    return $self->_validate_base_Num4('sm');
};

1;
