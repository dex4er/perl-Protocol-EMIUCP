package Protocol::EMIUCP::Message::Object;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;
use Protocol::EMIUCP::Message::Field;

has [qw( o_r )];
has_field [qw( trn len ot checksum )];

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(get_linear_isa);

sub new {
    my ($class, %args) = @_;

    $class->_build_args(\%args);

    my %fields;
    my $field_names = $class->list_field_names(\%args);
    @fields{ @$field_names } = @args{ @$field_names };
    map { delete $fields{$_} } grep { not defined $fields{$_} or $fields{$_} eq '' } keys %fields;

    my $self = { %fields };
    bless $self => $class;

    if (not defined $self->{len}) {
        $self->{len} = $self->_calculate_len;
        delete $self->{checksum};
    };

    if (not defined $self->{checksum}) {
        $self->{checksum} = $self->_calculate_checksum;
    };

    return $self;
};

sub new_from_string {
    my ($class, $str) = @_;
    return $class->new( %{ $class->_parse_string($str) } );
};

sub validate {
    my ($self) = @_;

    foreach my $name (@{ $self->list_required_field_names }) {
        confess "Attribute ($name) is required"
            unless defined $self->{$name};
    };

    foreach my $name (@{ $self->list_empty_field_names }) {
        confess "Attribute ($name) should not be defined"
            if defined $self->{$name};
    };

    $self->$_ foreach grep { $self->can($_) }
        map { /::(\w+)$/; '_validate_' . lc $1 } @{ $self->_list_roles };

    return $self;
};

sub list_data_field_names {
    confess "Method (list_data_field_names) have to be overrided by derived class method";
};

sub list_required_field_names {
    return +[];
};

sub list_empty_field_names {
    return +[];
};

sub list_field_names {
    my ($self, $fields) = @_;
    return [
        qw( trn len o_r ot ),
        @{ $self->list_data_field_names($fields) },
        qw( checksum )
    ];
};

sub _parse_string {
    my ($class, $str) = @_;
    my %args;
    my @fields = split '/', $str;
    @args{ @{ $class->list_field_names(\@fields) } } = @fields;
    map { delete $args{$_} } grep { not defined $args{$_} or $args{$_} eq '' } keys %args;
    return \%args;
};

sub as_string {
    my ($self) = @_;
    join '/', map { defined $self->{$_} ? $self->{$_} : '' } @{ $self->list_field_names };
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = +{ %$self };
    $self->_build_hashref($hashref);
    return $hashref;
};

sub _build_hashref {
    my ($self, $hashref) = @_;
    $self->$_($hashref) foreach grep { $self->can($_) }
        map { /::(\w+)$/; '_build_hashref_' . lc $1 } @{ $self->_list_roles };
};

1;
