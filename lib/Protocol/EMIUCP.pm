package Protocol::EMIUCP;

use 5.008;

our $VERSION = '0.01';


# Factory class

use Moose;

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Util qw(SEP);


sub new_message {
    my ($class, %args) = @_;
    Protocol::EMIUCP::Message->new(%args);
};


sub new_message_from_string {
    my ($class, $str) = @_;
    Protocol::EMIUCP::Message->new_from_string($str);
};


1;
