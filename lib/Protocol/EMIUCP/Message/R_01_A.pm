package Protocol::EMIUCP::Message::R_01_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw( Protocol::EMIUCP::Message::Base::R_A Protocol::EMIUCP::Message::Base::sm_adc_scts );

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( sm )] );

sub new {
    my ($class, %args) = @_;

    $class->sm_build_args(\%args);

    return $class->SUPER::new(%args);
};

sub validate {
    my ($self) = @_;

    $self->sm_validate;

    return $self;
};

sub list_data_field_names {
    return qw( ack sm );
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = $self->SUPER::as_hashref;
    $self->sm_build_hashref($hashref);
    return $hashref;
};

1;
