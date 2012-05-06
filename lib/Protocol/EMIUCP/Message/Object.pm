package Protocol::EMIUCP::Message::Object;

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

with_field [qw( o_r trn len ot checksum )];

sub import {
    # export constants with roles
};

sub BUILD {
    my ($self, $args) = @_;

    for my $n ($self->list_field_names($args)) {
        delete $self->{"clear_$n"}
            if exists $self->{"clear_$n"} and (not defined $self->{$n} or $self->{$n} eq '');
    };

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

sub list_data_field_names {
    confess "Method (list_data_field_names) have to be overrided by derived class method";
};

sub list_field_names {
    my ($self, $fields) = @_;
    return [
        qw( trn len o_r ot ),
        @{ $self->list_data_field_names($fields) },
        qw( checksum ),
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

sub _make_hashref {
    my ($self, $hashref) = @_;
    # should be overrided by roles
    return $hashref;
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = +{ %$self };
    $self->_make_hashref($hashref);
    return $hashref;
};

sub Dump {
    eval {
        require YAML::XS;
        YAML::XS::Dump(@_);
    } or do {
        require YAML;
        YAML::Dump(@_);
    };
};

__PACKAGE__->meta->make_immutable();

1;
