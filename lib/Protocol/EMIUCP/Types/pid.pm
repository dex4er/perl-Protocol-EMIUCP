package Protocol::EMIUCP::Types::pid;

use 5.006;

our $VERSION = '0.01';


use Moose;
use Moose::Util::TypeConstraints;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

our %PID_To_Message = (
    '0100' => 'Mobile Station',
    '0122' => 'Fax Group 3',
    '0131' => 'X.400',
    '0138' => 'Menu over PSTN',
    '0139' => 'PC via PSTN',
    '0339' => 'PC via X.25',
    '0439' => 'PC via ISDN',
    '0539' => 'PC via TCP/IP',
    '0639' => 'PC via Abbreviated Number',
);

our %Message_To_PID = reverse %PID_To_Message;

use constant ();

my @pid_constants;
foreach (keys %Message_To_PID) {
    my $name = 'PID_' . $_;
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W+/_/g;
    push @pid_constants, $name;
    constant->import($name => $Message_To_PID{$_});
};

use Exporter ();
our @EXPORT = @pid_constants;
*import = \&Exporter::import;

use Protocol::EMIUCP::Types;

coerce 'Protocol::EMIUCP::Types::pid'
    => from Any
    => via { Protocol::EMIUCP::Types::pid->new( value => $_ ) };

has value => (is => 'ro', isa => 'EMIUCP_PID', coerce => 1, required => 1);

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub as_message {
    my ($self) = @_;
    return $PID_To_Message{$self->value};
};


__PACKAGE__->meta->make_immutable();

1;
