package Protocol::EMIUCP::Message::O_51;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::O_50
    Protocol::EMIUCP::Message::Base::OT_51
);

use Carp qw(confess);

sub build_args {
    my ($class, $args) = @_;

    return $class->SUPER::build_args($args)
                 ->build_ot_51_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (oadc) is required"
        unless defined $self->{oadc};

    return $self->SUPER::validate
                ->validate_ot_51;
};

use constant list_valid_npid_codes => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

use constant list_valid_lpid_codes => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

1;
