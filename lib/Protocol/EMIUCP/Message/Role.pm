package Protocol::EMIUCP::Message::Role;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Message::Exception;
use Protocol::EMIUCP::Message::Field;

with_field [qw( trn len o r ot ack nack checksum )];

has '_string' => (
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    reader    => 'as_string',
    builder   => '_build_string',
);

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::DDT };

sub BUILD {
    my ($self, $args) = @_;

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

    if (ref $self) {
        return [
            qw( trn len ),
            eval { $self->o } ? qw( o ) :
            eval { $self->r } ? qw( r ) : qw( -or ),
            qw( ot ),
            eval { $self->r } ? (
                eval { $self->ack } ? qw( ack ) :
                eval { $self->nack } ? qw( nack ) : qw( -ack ),
            ) : (),
            @{ $self->list_data_field_names($fields) },
            qw( checksum ),
        ];
    }
    elsif (ref $fields eq 'ARRAY') {
        return [
            qw( trn len ),
            $fields->[2] eq 'O' ? qw( o ) :
            $fields->[2] eq 'R' ? qw( r ) : qw( -or ),
            qw( ot ),
            $fields->[2] eq 'R' ? (
                $fields->[4] eq 'A' ? qw( ack ) :
                $fields->[4] eq 'N' ? qw( nack ) : qw( -ack ),
            ) : (),
            @{ $self->list_data_field_names($fields) },
            qw( checksum ),
        ];
    }
    else {
        return [
            qw( trn len ),
            $fields->{o} ? qw( o ) :
            $fields->{r} ? qw( r ) : qw( -or ),
            qw( ot ),
            $fields->{r} ? (
                $fields->{ack} ? qw( ack ) :
                $fields->{nack} ? qw( nack ) : qw( -ack ),
            ) : (),
            @{ $self->list_data_field_names($fields) },
            qw( checksum ),
        ];
    }
};

sub _parse_string {
    my ($class, $str) = @_;
    my %args;
    my @fields = split '/', $str;
    @args{ @{ $class->list_field_names(\@fields) } } = @fields;
    map { delete $args{$_} } grep { not defined $args{$_} or $args{$_} eq '' } keys %args;
    return \%args;
};

sub _build_string {
    my ($self) = @_;
    return join '/',
        map { my $f = $self->$_; defined $f ? $f : '' }
        @{ $self->list_field_names };
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

    return $hashref;
};

sub clone {
    my ($self, %args) = @_;
    my %attrs = map { $_ => $self->{$_} } grep { !/_|^(len|checksum)$/ } keys %$self;
    return Protocol::EMIUCP::Message->new(%attrs, %args);
};

sub new_response {
    my ($self, %args) = @_;

    Protocol::EMIUCP::Message::Exception->new(
        message       => 'The message is already a reponse',
        emiucp_string => $self->as_string,
    ) if $self->r;

    return Protocol::EMIUCP::Message->new(
        trn => $self->trn,
        ot  => $self->ot,
        r   => 1,
        %args,
    );
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
