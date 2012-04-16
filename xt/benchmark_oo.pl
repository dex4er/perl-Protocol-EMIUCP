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


use Protocol::EMIUCP;

my $str = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';

my %tests = (
    '1_Blessed' => sub {

        my $msg = My::Blessed->new($str);
        die $msg->as_string if $msg->as_string ne $str;

    },
    '2_Moose' => sub {

        my $msg = My::Moose->new($str);
        die $msg->as_string if $msg->as_string ne $str;

    },
    '3_MooseImmutable' => sub {

        my $msg = My::MooseImmutable->new($str);
        die $msg->as_string if $msg->as_string ne $str;

    },
    '4_EMIUCP' => sub {

        my $msg = Protocol::EMIUCP::Message->new_from_string($str);
        die $msg->as_string if $msg->as_string ne $str;

    },
);

use Benchmark ':all';

my $result = timethese($ARGV[0] || -1, { %tests });
cmpthese($result);
