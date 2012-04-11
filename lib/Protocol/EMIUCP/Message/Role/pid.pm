package Protocol::EMIUCP::Message::Role::pid;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;
use Protocol::EMIUCP::Field::pid;

has_field 'pid';

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{pid}) {
        $hashref->{pid} = $self->pid_as_string;
        $hashref->{pid_message} = $self->pid_message;
    };
    return $hashref;
};


1;
