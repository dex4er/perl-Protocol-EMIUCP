package Protocol::EMIUCP::Message::Role::Field::vp;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role);

use Carp qw(confess);
use Scalar::Util qw(blessed);
use Protocol::EMIUCP::Util qw(has);

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::VP };

has 'vp';

sub build_args_vp {
    my ($class, $args) = @_;

    $args->{vp} = DateTime::Format::EMIUCP::VP->format_datetime($args->{vp})
        if blessed $args->{vp} and $args->{vp}->isa('DateTime');

    return $class;
};

sub validate_vp {
    my ($self) = @_;

    confess "Attribute (vp) is invalid"
        if defined $self->{vp} and not $self->{vp}  =~ /^\d{10}$/;

    return $self;
};

sub vp_datetime {
    my ($self) = @_;

    return unless defined $self->{vp};
    return DateTime::Format::EMIUCP::VP->parse_datetime($self->{vp});
};

sub build_hashref_vp {
    my ($self, $hashref) = @_;

    $hashref->{vp_datetime} = $self->vp_datetime->datetime
        if HAVE_DATETIME and defined $hashref->{vp};

    return $self;
};

1;
