package Protocol::EMIUCP::Message::Role;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

with_field [qw( o_r trn len ot checksum )];

has '_string_cached' => (
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    reader    => 'as_string',
    builder   => '_as_string',
);

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::DDT };

sub import {
    # export constants with roles
};

sub BUILDARGS {
    my ($self, %args) = @_;

    foreach my $name (keys %args) {
        delete $args{$name} if not defined $args{$name} or $args{$name} eq '';
    };

    return \%args;
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

requires 'list_data_field_names';

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

sub _as_string {
    my ($self) = @_;
    return join '/',
        map { my $f = $self->$_; defined $f ? $f : '' }
        @{ $self->list_field_names };
};

sub _make_hashref {
    my ($self, $hashref) = @_;
    # should be overrided by roles
    return $hashref;
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = +{ %$self };

    my @attrs = grep { not /^_/ } map { $_->name } $self->meta->get_all_attributes;

    foreach my $name (@attrs) {
        my $value = $self->$name;
        if (defined $value) {
            $hashref->{$name} = $value;
            $hashref->{$name} = $hashref->{$name}->datetime
                if HAVE_DATETIME and blessed $value and $value->isa('DateTime');
        };
    };

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

1;
