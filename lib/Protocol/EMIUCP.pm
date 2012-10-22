package Protocol::EMIUCP;

use 5.006;

use Mouse;

our $VERSION = '0.01';


# Factory class through proxy class

use Protocol::EMIUCP::Message;


sub new_message {
    my ($class, %args) = @_;
    Protocol::EMIUCP::Message->new(%args);
};


sub new_message_from_string {
    my ($class, $str) = @_;
    Protocol::EMIUCP::Message->new_from_string($str);
};

sub parse_message_from_string {
    my ($class, $str) = @_;
    Protocol::EMIUCP::Message->parse_string($str);
};


1;
