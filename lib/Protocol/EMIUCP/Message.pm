package Protocol::EMIUCP::Message;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Util qw(SEP);
use Protocol::EMIUCP::Types;

has trn      => (is => 'ro', isa => 'Int2', coerce => 1, default => 0);
has len      => (is => 'ro', isa => 'Int5', coerce => 1, writer => '_set_len', predicate => 'has_len');
has checksum => (is => 'ro', isa => 'Hex2', coerce => 1, writer => '_set_checksum', predicate => 'has_checksum', clearer => '_clear_checksum');

sub BUILD { };
after BUILD => sub {
    my ($self) = @_;
    confess sprintf 'LEN mismatch, should be ' . $self->calculate_len
        if $self->has_len and $self->len ne $self->calculate_len;
    confess 'checksum mismatch, should be ' . $self->calculate_checksum
        if $self->has_checksum and $self->checksum ne $self->calculate_checksum;

    if (not $self->has_len) {
        $self->_set_checksum(0);
        $self->_set_len(0);
        $self->_set_len($self->calculate_len);
        $self->_clear_checksum;
    };

    if (not $self->has_checksum) {
        $self->_set_checksum($self->calculate_checksum);
    };
};

sub calculate_len {
    my ($self) = @_;
    return sprintf "%05d", length $self->to_string;
};

use List::Util 'sum';

sub calculate_checksum {
    my ($self) = @_;
    my $s = $self->to_string =~ s{[^/]*$}{}r;
    my $c += sum unpack "C*", $s;
    return sprintf "%02X", $c % 16**2;
};

requires 'list_data_field_names';

sub list_field_names {
    my ($self, @fields) = @_;
    my @names = (
        qw( trn len o_r ot ),
        $self->list_data_field_names(@fields),
        qw( checksum )
    );
    return wantarray ? @names : \@names;
};

sub parse_fields { };
around parse_fields => sub {
    my ($orig, $class, @fields) = @_;
    my %args = $class->$orig(@fields);
    @args{$class->list_field_names(@fields)} = @fields;
    map { delete $args{$_} } grep { $args{$_} eq '' } keys %args;
    return %args;
};

sub new_from_string {
    my ($class, $str) = @_;
    my @fields = split SEP, $str;
    my %args = $class->parse_fields(@fields);
    $class->new(%args);
};

sub to_string {
    my ($self) = @_;
    join SEP, map { my $field = $self->$_; defined $field ? $field : '' }
        $self->list_field_names;
};


1;
