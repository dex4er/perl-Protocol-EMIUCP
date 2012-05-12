package Protocol::EMIUCP::Message::Role::Field::nadc;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'nadc' => (
    isa       => 'EMIUCP_Num16',
    trigger   => sub {
        if ($_[0]->{npid}||0 eq '0539') {
            confess "Attribute (nadc) is invalid with value " . $_[0]->{nadc}
                unless defined $_[0]->_from_nadc_to_addr($_[0]->{nadc});
        }
        else {
            confess "Attribute (nadc) is invalid with value " . $_[0]->{nadc}
                unless $_[0]->{nadc} =~ /^\d{1,16}$/;
        };
    },
);

has 'nadc_addr' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_nadc_addr',
    trigger   => sub {
        $_[0]->{nadc} = $_[0]->_from_addr_to_nadc($_[1])
            || confess "Attribute (nadc_addr) is invalid with value " . $_[1];
    },
    lazy      => 1,
    default   => sub { defined $_[0]->{nadc} ? $_[0]->_from_nadc_to_addr($_[0]->{nadc}) : undef }
);

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

1;
