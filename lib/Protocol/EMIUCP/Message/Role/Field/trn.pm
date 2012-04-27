package Protocol::EMIUCP::Message::Role::Field::trn;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'trn';

use Carp qw(confess);

sub _build_args_trn {
    my ($class, $args) = @_;

    no warnings 'numeric';
    $args->{trn} = sprintf "%02d", ($args->{trn} || 0) % 100;

    return $class;
};

sub _validate_trn {
    my ($self) = @_;

    confess "Attribute (trn) is invalid"
        if defined $self->{trn} and not $self->{trn} =~ /^\d{2}$/;

    return $self;
};

1;
