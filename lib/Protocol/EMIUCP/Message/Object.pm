package Protocol::EMIUCP::Message::Object;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

has [qw( trn len o_r ot checksum )];

use Carp qw(confess);
use List::Util qw(sum);
use Protocol::EMIUCP::Util qw(get_linear_isa);

sub new {
    my ($class, %args) = @_;

    {
        no warnings 'numeric';
        $args{trn}  = sprintf "%02d", ($args{trn} || 0) % 100;
        $args{len}  = sprintf "%05d", $args{len} if defined $args{len};
        $args{ot}   = sprintf "%02d", $args{ot}  if defined $args{ot};
    }

    $class->build_args(\%args);

    my $self = +{};
    my $field_names = $class->list_field_names(\%args);
    @{$self}{ @$field_names } = @args{ @$field_names };
    map { delete $self->{$_} } grep { not defined $self->{$_} or $self->{$_} eq '' } keys %$self;
    bless $self => $class;

    if (not defined $self->{len}) {
        $self->{len} = $self->calculate_len;
        delete $self->{checksum};
    };

    if (not defined $self->{checksum}) {
        $self->{checksum} = $self->calculate_checksum;
    };

    return $self;
};

sub new_from_string {
    my ($class, $str) = @_;
    return $class->new( %{ $class->parse_string($str) } );
};

sub list_message_roles {
    my ($self) = @_;

    no strict 'refs';
    my $class = ref $self ? ref $self : $self;

    return [
        grep { $_->can('does') and $_->does('Protocol::EMIUCP::Message::Role') }
            @{ get_linear_isa $class }
    ];
};

sub build_args {
    my ($class, $args) = @_;
    $class->$_($args) foreach grep { $class->can($_) }
        map { /::(\w+)$/; '_build_args_' . lc $1 } @{ $class->list_message_roles };
};

sub validate {
    my ($self) = @_;

    confess "Attribute (len) has invalid value, should be " . $self->calculate_len
        if defined $self->{len} and $self->{len} ne $self->calculate_len;
    confess "Attribute (checksum) is invalid, should be " . $self->calculate_checksum
        if defined $self->{checksum} and $self->{checksum} ne $self->calculate_checksum;

    foreach my $name (@{ $self->list_required_field_names }) {
        confess "Attribute ($name) is required"
            unless defined $self->{$name};
    };

    foreach my $name (@{ $self->list_empty_field_names }) {
        confess "Attribute ($name) should not be defined"
            if defined $self->{$name};
    };

    $self->$_ foreach grep { $self->can($_) }
        map { /::(\w+)$/; '_validate_' . lc $1 } @{ $self->list_message_roles };

    return $self;
};

sub calculate_len {
    my ($self, $str) = @_;
    $str = $self->as_string if not defined $str;

    my $len = length $str;

    $str =~ m{ ^ \d{2} / ( \d{5} )? / }x
        or confess "Invalid EMI-UCP message '$str'";
    $len += 5 if not defined $1;

    $str =~ m{ / ( [0-9A-F]{2} )? $ }x
        or confess "Invalid EMI-UCP message '$str'";
    $len += 2 if not defined $1;

    return sprintf "%05d", $len;
};

sub calculate_checksum {
    my ($self, $str) = @_;
    $str = $self->as_string if not defined $str;
    $str =~ m{ ^ (.* / ) (?: [0-9A-F]{2} )? $ }x
        or confess "Invalid EMI-UCP message '$str'";
    my $c += sum unpack "C*", $1;
    return sprintf "%02X", $c % 16**2;
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

sub parse_string {
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
    $self->build_hashref($hashref);
    return $hashref;
};

sub build_hashref {
    my ($self, $hashref) = @_;
    $self->$_($hashref) foreach grep { $self->can($_) }
        map { /::(\w+)$/; '_build_hashref_' . lc $1 } @{ $self->list_message_roles };
};

1;
