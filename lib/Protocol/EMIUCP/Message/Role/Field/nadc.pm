package Protocol::EMIUCP::Message::Role::Field::nadc;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'nadc' => (isa => 'EMIUCP_Num16');

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    if (defined $args{nadc_addr}) {
        my $nadc_addr = delete $args{nadc_addr};
        $args{nadc} = $class->_from_addr_to_nadc($nadc_addr)
            || confess "Attribute (nadc_addr) is invalid with value $nadc_addr";
    };

    return $class->$orig(%args);
};

{
    my $ip4dec   = '(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})';
    my $tcpport  = '(999[0-9]|99[0-8][0-9]|9[0-8][0-9]{2}|[0-8]?[0-9]{1,3})';

    sub _from_addr_to_nadc {
        my ($self, $addr) = @_;
        $addr =~ /^$ip4dec\.$ip4dec\.$ip4dec\.$ip4dec:$tcpport$/ or return;
        return sprintf '%03d%03d%03d%03d%d', $1, $2, $3, $4, $5;
    };
}

{
    my $ip4dec0  = '(25[0-5]|2[0-4][0-9]|[0-1][0-9]{1,2})';
    my $tcpport0 = '([0-9]{4})';

    sub _from_nadc_to_addr {
        my ($self, $nadc) = @_;
        $nadc =~ /^$ip4dec0$ip4dec0$ip4dec0$ip4dec0$tcpport0$/ or return;
        return sprintf '%d.%d.%d.%d:%d', $1, $2, $3, $4, $5;
    };
}

before BUILD => sub {
    my ($self) = @_;

    if (defined $self->{nadc}) {
        if ($self->{npid} eq '0539') {
            confess "Attribute (nadc) is invalid with value " . $self->{nadc}
                unless defined $self->_from_nadc_to_addr($self->{nadc});
        }
        else {
            confess "Attribute (nadc) is invalid with value " . $self->{nadc}
                unless $self->{nadc} =~ /^\d{1,16}$/;
        };
    };

    return $self;
};

sub nadc_addr {
    my ($self) = @_;
    return $self->_from_nadc_to_addr($self->{nadc});
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $self->{nadc}) {
        $hashref->{nadc_addr} = $self->nadc_addr
            if defined $self->{npid} and $self->{npid} eq '0539';
    };
};

1;
