#!/usr/bin/perl

# The simple EMI-UCP protocol client
#
# Example:
#     ucpclient.pl 127.0.0.1 12345 ot=51 adc=123 oadc=456 amsg=TEST

use strict;
use warnings;

use if $^O =~ /^(MSWin32|cygwin|interix)$/, maybe => 'POSIX::strftime::GNU';

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use IO::File;
use IO::Socket::INET;

use Scalar::Util qw(blessed);

die "Usage: $0 host port field=value field=value...\n" unless @ARGV;

$ENV{PERL_ANYEVENT_LOG} = 'filter=note' unless defined $ENV{PERL_ANYEVENT_LOG};

my ($host, $port, @args) = @ARGV;

my %opts = (PeerAddr => "$host:$port", map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { /^[A-Z]/ } @args);
my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } grep { /^[a-z]/ } @args;

my $sock = IO::Socket::INET->new(
    %opts,
) or die "Can't connect EMI-UCP server: $!";
$sock->blocking(0) or die "Can't set socket to non-blocking: $!'";

my $conn = Protocol::EMIUCP::Connection->new(
    fh          => $sock,
    defined $opts{Window} ? (
        window  => $opts{Window},
    ) : (),
    defined $opts{Pwd} ? (
        login => defined $opts{Login} ? $opts{Login} : $fields{oadc},
        pwd   => $opts{Pwd},
    ) : (),
    on_message => sub {
        my ($self, $msg) = @_;
        if ($msg->o) {
            # Not allowed by client
            my $rpl = $msg->new_response(
                nack => 1,
                ec => EC_OPERATION_NOT_ALLOWED,
                sm => ' ucpclient does not support this operation',
            );
            $self->write_message($rpl);
        };
    },
);

$conn->login_session;

if ($opts{AdcFromFile}) {
    my $fh = IO::File->new($opts{AdcFromFile})
        or die "Can not open file `$opts{AdcFromFile}': $!";
    while (my $adc = $fh->getline) {
        chomp $adc;
        next unless $adc =~ /^\d+$/;
        my $msg = Protocol::EMIUCP::Message->new(%fields, adc => $adc);
        $conn->wait_for_any_free_out_slot;
        $conn->write_message($msg);
    };
}
else {
    my $msg = Protocol::EMIUCP::Message->new(%fields);

    for (my $i = 1; $i <= ($opts{Requests}||1); $i++) {
        $conn->wait_for_any_free_out_slot;
        $conn->write_message($msg);
    };
};

$conn->wait_for_all_free_slots;

$conn->wait($opts{Wait}) if $opts{Wait};

END {
    $conn->DISPOSE if $conn;
}
