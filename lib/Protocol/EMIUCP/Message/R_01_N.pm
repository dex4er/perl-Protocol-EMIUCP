package Protocol::EMIUCP::Message::R_01_N;

use 5.006;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::R_N';

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( ec sm )] );

sub list_data_field_names {
    return qw( nack ec sm );
};

sub list_ec_codes {
    return qw( 01 02 03 04 05 06 07 08 24 23 26 );
};

__PACKAGE__->meta->make_immutable();

1;
