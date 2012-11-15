#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 16;

use Protocol::EMIUCP::Session;
use Protocol::EMIUCP::Message;

use AnyEvent;

my (@msg_in, @msg_out, @msg_err);

my $make_session = sub {
    my %args = @_;
    Protocol::EMIUCP::Session->new(
        window => $args{window} || 1,
        timeout => 3,
        login => 1234,
        pwd => 'password',
        on_write => sub {
            my ($sess, $msg) = @_;
            push @msg_out, $msg;
            $args{on_write}->($sess, $msg) if $args{on_write};
        },
        on_read => sub {
            my ($sess, $msg) = @_;
            push @msg_in, $msg;
            $args{on_read}->($sess, $msg) if $args{on_read};
        },
        on_timeout => sub {
            my ($sess, $where, $msg) = @_;
            push @msg_err, $msg;
            $args{on_timeout}->($sess, $msg) if $args{on_timeout};
        },
    );
};

my $msg_in = Protocol::EMIUCP::Message->new(
    trn => 42, ot => 52, o => 1, oadc => 123456789, adc => 321,
    mt => 3, amsg_utf8 => 'PING',
    scts => '010203040506',
);
my $msg_out = Protocol::EMIUCP::Message->new(
    ot => 51, o =>1, oadc => $msg_in->adc, adc => $msg_in->oadc,
    mt => 3, amsg_utf8 => 'PONG'
);

{
    @msg_in = @msg_out = @msg_err = ();

    my @timers;
    my $sess = $make_session->(
        on_write => sub {
            my ($sess, $msg) = @_;
            push @timers, AE::timer 1, 0, sub {
                $sess->read_message($msg->new_response(ack => 1)) if $msg->o;
            };
        },
        on_read => sub {
            my ($sess, $msg) = @_;
            push @timers, AE::timer 1, 0, sub {
                $sess->write_message($msg->new_response(ack => 1)) if $msg->o;
            };
        },
    );

    eval {
        $sess->read_message($msg_in);
        $sess->write_message($msg_out);
    };

    is "$@", '', 'read and write without error';

    $sess->wait_for_all_free_slots;

    $sess->DISPOSE;
    @timers = ();

    is '<'.join('><', sort map { $_->as_string } @msg_out).'>',
       '<00/00070/O/51/123456789/321/////////////////3//504F4E47/////////////40>'.
       '<42/00020/R/52/A///9B>',
       'read and write without error: out';

    is '<'.join('><', sort map { $_->as_string } @msg_in).'>',
       '<00/00020/R/51/A///94>'.
       '<42/00082/O/52/321/123456789/////////////010203040506////3//50494E47/////////////92>',
       'read and write without error: in';

    is '<'.join('><', sort map { $_->as_string } @msg_err).'>',
       '<>',
       'read and write without error: err';
}

{
    @msg_in = @msg_out = @msg_err = ();

    my @timers;
    my $sess = $make_session->();

    eval {
        $sess->write_message($msg_out);
    };

    is "$@", '', 'O/51 without reponse';

    $sess->wait_for_all_free_slots;

    $sess->DISPOSE;

    is '<'.join('><', sort map { $_->as_string } @msg_out).'>',
       '<00/00070/O/51/123456789/321/////////////////3//504F4E47/////////////40>',
       'O/51 without reponse: out';

    is '<'.join('><', sort map { $_->as_string } @msg_in).'>',
       '<>',
       'O/51 without reponse: in';

    is '<'.join('><', sort map { $_->as_string } @msg_err).'>',
       '<00/00070/O/51/123456789/321/////////////////3//504F4E47/////////////40>',
       'O/51 without reponse: err';
}

{
    @msg_in = @msg_out = @msg_err = ();

    my @timers;
    my $sess = $make_session->(
        on_write => sub {
            my ($sess, $msg) = @_;
            push @timers, AE::timer 1, 0, sub {
                $sess->read_message($msg->new_response(ack => 1)) if $msg->o;
            };
        },
    );

    eval {
        $sess->write_message($msg_out);
        $sess->write_message($msg_out);
    };

    like "$@", qr/^No free slot found:/, '2 writes with too small window';

    $sess->wait_for_all_free_slots;

    $sess->DISPOSE;
    @timers = ();

    is '<'.join('><', sort map { $_->as_string } @msg_out).'>',
       '<00/00070/O/51/123456789/321/////////////////3//504F4E47/////////////40>',
       'write with too small window: out';

    is '<'.join('><', sort map { $_->as_string } @msg_in).'>',
       '<00/00020/R/51/A///94>',
       'write with too small window: in';

    is '<'.join('><', sort map { $_->as_string } @msg_err).'>',
       '<>',
       'write with too small window: err';
}

{
    @msg_in = @msg_out = @msg_err = ();

    my @timers;
    my $sess = $make_session->(
        window => 2,
        on_write => sub {
            my ($sess, $msg) = @_;
            push @timers, AE::timer 1, 0, sub {
                $sess->read_message($msg->new_response(ack => 1)) if $msg->o;
            };
        },
    );

    eval {
        $sess->write_message($msg_out);
        $sess->write_message($msg_out);
    };

    is "$@", '', '2 writes with proper window';

    $sess->wait_for_all_free_slots;

    $sess->DISPOSE;
    @timers = ();

    is '<'.join('><', sort map { $_->as_string } @msg_out).'>',
       '<00/00070/O/51/123456789/321/////////////////3//504F4E47/////////////40>'.
       '<01/00070/O/51/123456789/321/////////////////3//504F4E47/////////////41>',
       '2 writes with proper window: out';

    is '<'.join('><', sort map { $_->as_string } @msg_in).'>',
       '<00/00020/R/51/A///94>'.
       '<01/00020/R/51/A///95>',
       '2 writes with proper window: in';

    is '<'.join('><', sort map { $_->as_string } @msg_err).'>',
       '<>',
       '2 writes with proper window: err';
}
