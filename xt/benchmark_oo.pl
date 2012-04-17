#!/usr/bin/perl

use lib 'lib', '../lib';

{
    package My::Blessed;
    sub new {
        my ($class, $str) = @_;
        my %msg;
        @msg{qw( trn len o_r ot adc oadc ac mt amsg checksum )} = split '/', $str;
        return bless \%msg => $class;
    };
    sub as_string {
        my ($self) = @_;
        return join '/', @{$self}{qw( trn len o_r ot adc oadc ac mt amsg checksum )};
    }
};

{
    package My::Moose;
    use Moose;
    has [qw( trn len o_r ot adc oadc ac mt amsg checksum )] => (is => 'ro', isa => 'Str');
    around BUILDARGS => sub {
        my ($orig, $class, $str) = @_;
        my %args;
        @args{qw( trn len o_r ot adc oadc ac mt amsg checksum )} = split '/', $str;
        return $class->$orig(%args);
    };
    sub as_string {
        my ($self) = @_;
        return join '/', @{$self}{qw( trn len o_r ot adc oadc ac mt amsg checksum )};
    }
};

{
    package My::MooseImmutable;
    use Moose;
    has [qw( trn len o_r ot adc oadc ac mt amsg checksum )] => (is => 'ro', isa => 'Str');
    around BUILDARGS => sub {
        my ($orig, $class, $str) = @_;
        my %args;
        @args{qw( trn len o_r ot adc oadc ac mt amsg checksum )} = split '/', $str;
        return $class->$orig(%args);
    };
    sub as_string {
        my ($self) = @_;
        return join '/', @{$self}{qw( trn len o_r ot adc oadc ac mt amsg checksum )};
    }
    __PACKAGE__->meta->make_immutable();
};


use Protocol::EMIUCP::Message;

my $str_01 = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';
my $str_31 = '02/00035/O/31/0234765439845/0139/A0';

my %tests = (
    '1_Blessed' => sub {

        my $msg = My::Blessed->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    '2_Moose' => sub {

        my $msg = My::Moose->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    '3_MooseImmutable' => sub {

        my $msg = My::MooseImmutable->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    '4_EMIUCP_01' => sub {

        my $msg = Protocol::EMIUCP::Message->new_from_string($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    '5_EMIUCP_31' => sub {

        my $msg = Protocol::EMIUCP::Message->new_from_string($str_31);
        die $msg->as_string if $msg->as_string ne $str_31;

    },
);

use Benchmark ':all';

my $result = timethese($ARGV[0] || -1, { %tests });
cmpthese($result);
