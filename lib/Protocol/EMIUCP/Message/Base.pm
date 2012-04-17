package Protocol::EMIUCP::Message::Base;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use List::Util qw(sum);

__PACKAGE__->make_accessors( [qw( trn len o_r ot checksum )] );

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
    my @field_names = $class->list_field_names(\%args);
    @{$self}{ @field_names } = @args{ @field_names };
    map { delete $self->{$_} } grep { not defined $self->{$_} or $self->{$_} eq '' } keys %$self;
    bless $self => $class;

    confess "Attribute (len) has invalid value, should be " . $self->calculate_len
        if defined $self->{len} and $self->{len} ne $self->calculate_len;
    confess "Attribute (checksum) is invalid, should be " . $self->calculate_checksum
        if defined $self->{checksum} and $self->{checksum} ne $self->calculate_checksum;

    if (not defined $self->{len}) {
        $self->{len} = $self->calculate_len;
        delete $self->{checksum};
    };

    if (not defined $self->{checksum}) {
        $self->{checksum} = $self->calculate_checksum;
    };

    return $self;
};

sub build_args {
    # Base class does nothing
};

sub validate {
    # Base class does nothing
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

sub list_field_names {
    my ($self, $fields) = @_;
    my @names = (
        qw( trn len o_r ot ),
        @{ $self->list_data_field_names($fields) },
        qw( checksum )
    );
    return wantarray ? @names : \@names;
};

sub parse_string {
    my ($class, $str) = @_;
    my %args;
    my @fields = split '/', $str;
    @args{ $class->list_field_names(\@fields) } = @fields;
    map { delete $args{$_} } grep { not defined $args{$_} or $args{$_} eq '' } keys %args;
    return wantarray ? %args : \%args;
};

sub new_from_string {
    my ($class, $str) = @_;
    my %args = $class->parse_string($str);
    $class->new(%args);
};

sub as_string {
    my ($self) = @_;
    join '/', map { defined $self->{$_} ? $self->{$_} : '' } $self->list_field_names;
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = +{ %$self };
    $self->build_hashref($hashref);
    return $hashref;
};

sub build_hashref {
    # Base class does nothing
};

sub make_accessors {
    my ($class, $attrs) = @_;
    my $caller = caller();
    no strict 'refs';
    foreach my $name (@$attrs) {
        *{"${caller}::$name"}     = sub { $_[0]->{$name} };
        *{"${caller}::has_$name"} = sub { exists $_[0]->{$name} };
    };
};

1;
