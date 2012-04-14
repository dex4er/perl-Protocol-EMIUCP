package Protocol::EMIUCP::Field::pid;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::pid;
use Protocol::EMIUCP::Field;

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
