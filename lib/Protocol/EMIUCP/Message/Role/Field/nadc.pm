package Protocol::EMIUCP::Message::Role::Field::nadc;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'nadc';

use Carp qw(confess);

use Protocol::EMIUCP::Message::Role::Field::npid;
BEGIN { Protocol::EMIUCP::Message::Role::Field::npid->import_npid };

sub build_args_nadc {
    my ($class, $args) = @_;

    $args->{nadc} = $class->_from_addr_to_nadc($args->{nadc_addr})
        || confess "Attribute (nadc_addr) is invalid"
        if defined $args->{nadc_addr};

    return $class;
};

{
    my $ip4dec  = '(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})';
    my $tcpport = '(999[0-9]|99[0-8][0-9]|9[0-8][0-9]{2}|[0-8]?[0-9]{1,3})';

    sub _from_addr_to_nadc {
        my ($self, $addr) = @_;
        $addr =~ /^$ip4dec\.$ip4dec\.$ip4dec\.$ip4dec:$tcpport$/ or return;
        return sprintf '%03d%03d%03d%03d%d', $1, $2, $3, $4, $5;
    };

    sub _from_nadc_to_addr {
        my ($self, $nadc) = @_;
        $nadc =~ /^$ip4dec$ip4dec$ip4dec$ip4dec$tcpport$/ or return;
        return sprintf '%d.%d.%d.%d:%d', $1, $2, $3, $4, $5;
    };
}

sub validate_nadc {
    my ($self) = @_;

    if (defined $self->{nadc}) {
        if ($self->{npid} eq NPID_PC_VIA_TCP_IP) {
            confess "Attribute (nadc) is invalid"
                unless defined $self->_from_nadc_to_addr($self->{nadc});
        }
        else {
            confess "Attribute (nadc) is invalid"
                unless $self->{nadc} =~ /^\d{1,16}$/;
        };
    };

    return $self;
};

sub nadc_addr {
    my ($self) = @_;
    return $self->_from_nadc_to_addr($self->{nadc});
};

sub build_hashref_nadc {
    my ($self, $hashref) = @_;

    if (defined $self->{nadc}) {
        $hashref->{nadc_addr} = $self->nadc_addr
            if defined $self->{npid} and $self->{npid} eq NPID_PC_VIA_TCP_IP;
    };
    return $self;
};

1;
