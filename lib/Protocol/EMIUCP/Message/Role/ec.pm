package Protocol::EMIUCP::Message::Role::ec;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;
use Protocol::EMIUCP::Field::ec;

has_field 'ec';

requires 'list_ec_codes';

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{ec}) {
        $hashref->{ec} = $self->ec_as_string;
        $hashref->{ec_message} = $self->ec_message;
    };
    return $hashref;
};


1;