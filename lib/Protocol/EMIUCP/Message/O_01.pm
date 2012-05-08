package Protocol::EMIUCP::Message::O_01;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['O']),  default => 'O');
has '+ot'  => (isa => enum(['01']), default => '01');

use Protocol::EMIUCP::Message::Field;

with_field [qw( adc oadc_num ac mt amsg nmsg )];
required_field [qw( adc mt )];

has '+mt'  => (isa => enum([qw( 2 3 )]));

my @MT_To_Field;
@MT_To_Field[2, 3] = qw( nmsg amsg );

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[7]
           : $fields->{mt};
    no warnings 'numeric';
    return [ qw( adc oadc ac mt ), $MT_To_Field[$mt||0] || '-msg' ];
};

__PACKAGE__->meta->make_immutable();

1;
