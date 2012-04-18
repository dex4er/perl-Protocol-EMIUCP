package Protocol::EMIUCP::Message::Field::pid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Field::Base::pid);

my %Methods = (
    import_pid        => '_import_base_pid',
    build_pid_args    => '_build_base_pid_args',
    validate_pid      => '_validate_base_pid',
    pid_message       => '_base_pid_message',
    build_pid_hashref => '_build_base_pid_hashref',
);

(my $field = __PACKAGE__) =~ s/.*:://;

foreach my $method (keys %Methods) {
    my $base_method = $Methods{$method};
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method($field, @args);
    };
};

1;

