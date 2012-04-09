package Protocol::EMIUCP::Message::O_01;

use 5.008;

our $VERSION = '0.01';


use Moose;

with 'Protocol::EMIUCP::Message::O';
with 'Protocol::EMIUCP::Message::OT_01';
with 'Protocol::EMIUCP::Message::amsg';

use Protocol::EMIUCP::Types;

has adc      => (is => 'ro', isa => 'Num16');
has oadc     => (is => 'ro', isa => 'Num16');
has ac       => (is => 'ro', isa => 'Str');
has mt       => (is => 'ro', isa => 'MT23', required => 1);
has nmsg     => (is => 'ro', isa => 'Num160', predicate => 'has_nmsg');

sub BUILD {
    my ($self) = @_;
    confess 'OT != 1' if $self->ot != 1;
    confess 'nmsg for MT=3' if $self->mt == 3 and $self->has_nmsg;
    confess 'amsg for MT=2' if $self->mt == 2 and $self->has_amsg;
};

sub list_data_field_names {
    my ($self, @fields) = @_;
    my $mt = (exists $fields[7] ? $fields[7] : $self->mt) || '';
    no warnings 'numeric';
    return qw( adc oadc ac mt ), $mt == 2 ? 'nmsg' : 'amsg';
};



1;
