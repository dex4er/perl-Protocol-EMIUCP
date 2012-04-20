package Protocol::EMIUCP::Message::O_51;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::OT_51
    Protocol::EMIUCP::Message::Role::O_50
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);

use constant list_valid_npid_values => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

use constant list_valid_lpid_values => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

sub validate {
    my ($self) = @_;

    $self->SUPER::validate;

    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (oadc) is required"
        unless defined $self->{oadc};

    return $self;
};

1;
