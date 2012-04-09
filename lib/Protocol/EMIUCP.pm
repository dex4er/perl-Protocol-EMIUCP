package Protocol::EMIUCP;

use 5.008;

our $VERSION = '0.01';


# Factory class through proxy class

use Moose;

use Protocol::EMIUCP::Message;


sub new_message {
    my ($class, %args) = @_;
    Protocol::EMIUCP::Message->new(%args);
};


sub new_message_from_string {
    my ($class, $str) = @_;
    Protocol::EMIUCP::Message->new_from_string($str);
};


__PACKAGE__->meta->make_immutable();

1;
