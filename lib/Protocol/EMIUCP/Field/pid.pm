package Protocol::EMIUCP::Field::pid;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::pid;
use Protocol::EMIUCP::Field;

requires 'list_pid_codes';

before BUILD => sub {
    my ($self) = @_;
    my $pid = $self->pid;
    confess "Validation failed for attribute (pid) with value $pid" unless grep { $_ == $pid } $self->list_pid_codes;
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{pid}) {
        $hashref->{pid}         = $self->pid_as_string;
        $hashref->{pid_message} = $self->pid_message;
    };
    return $hashref;
};


1;
