package Protocol::EMIUCP::Session::Exception;

use Mouse;

extends 'Protocol::EMIUCP::Message::Exception';

__PACKAGE__->meta->make_immutable;

no Mouse;

1;
