package Protocol::EMIUCP::Session::Slot::Exception;

use Mouse;

extends 'Protocol::EMIUCP::Exception';

use Protocol::EMIUCP::Message::Field;

with_field [qw( trn )];

has '+string_attributes' => (
    default   => sub { [qw( message trn error )] },
);

__PACKAGE__->meta->make_immutable;

no Mouse;

1;
