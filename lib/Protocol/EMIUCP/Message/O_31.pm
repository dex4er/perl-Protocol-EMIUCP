package Protocol::EMIUCP::Message::O_31;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['O']),  required => 1, default => 'O');
has '+ot'  => (isa => enum(['31']), required => 1, default => '31');

use Protocol::EMIUCP::Message::Field;

with_field [qw( adc pid )];
required_field [qw( adc pid )];

has '+pid' => (isa => enum([qw( 0100 0122 0131 0138 0139 0339 0439 0539 0639 )]));

use constant list_data_field_names => [qw( adc pid )];

__PACKAGE__->meta->make_immutable();

1;
