package Protocol::EMIUCP::Message::Role::Field::ot;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'ot';

use Carp qw(confess);

sub _build_args_ot {
    my ($class, $args) = @_;

    no warnings 'numeric';
    $args->{ot} = sprintf "%02d", $args->{ot} if defined $args->{ot};

    return $class;
};

1;
