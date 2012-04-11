package Protocol::EMIUCP::Message::O_01;

use 5.008;

our $VERSION = '0.01';

use Moose;

with 'Protocol::EMIUCP::Message::Role::O';
with 'Protocol::EMIUCP::Message::Role::OT_01';

use Protocol::EMIUCP::Field;

has_field [qw( adc oadc ac mt nmsg )];
with 'Protocol::EMIUCP::Message::Role::amsg';

sub BUILD {
    my ($self) = @_;
    confess 'OT != "01"' if $self->ot != 1;
    confess 'nmsg for MT=3' if $self->mt == 3 and $self->has_nmsg;
    confess 'amsg for MT=2' if $self->mt == 2 and $self->has_amsg;
};

sub list_data_field_names {
    my ($self, @fields) = @_;
    my $mt = (exists $fields[7] ? $fields[7] : $self->mt) || '';
    no warnings 'numeric';
    return qw( adc oadc ac mt ), $mt == 2 ? 'nmsg' : 'amsg';
};


__PACKAGE__->meta->make_immutable();

1;
