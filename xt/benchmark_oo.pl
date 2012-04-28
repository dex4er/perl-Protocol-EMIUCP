#!/usr/bin/perl

use lib 'lib', '../lib';

{
    package My::Blessed;
    sub new {
        my ($class, $str) = @_;
        my %msg;
        @msg{qw( trn len o_r ot adc oadc ac mt amsg checksum )} = split '/', $str;
        return bless \%msg => $class;
    }
    sub as_string {
        my ($self) = @_;
        return join '/', @{$self}{qw( trn len o_r ot adc oadc ac mt amsg checksum )};
    }
};

eval q{
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

eval q{
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

eval q{
    package My::Mouse;
    use Mouse;
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

eval q{
    package My::MouseImmutable;
    use Mouse;
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

eval q{
    package My::Mo;
    use Mo qw(is);
    has [qw( trn len o_r ot adc oadc ac mt amsg checksum )] => (is => 'ro', isa => 'Str');
    sub new {
        my ($class, $str) = @_;
        my %args;
        @args{qw( trn len o_r ot adc oadc ac mt amsg checksum )} = split '/', $str;
        return $class->SUPER::new(%args);
    };
    sub as_string {
        my ($self) = @_;
        return join '/', @{$self}{qw( trn len o_r ot adc oadc ac mt amsg checksum )};
    }
};

eval q{
    package My::VSO;
    use VSO;
    has $_ => (is => 'ro', isa => 'Str') foreach qw( trn len o_r ot adc oadc ac mt amsg checksum );
    sub new {
        my ($class, $str) = @_;
        my %args;
        @args{qw( trn len o_r ot adc oadc ac mt amsg checksum )} = split '/', $str;
        return $class->SUPER::new(%args);
    };
    sub as_string {
        my ($self) = @_;
        return join '/', @{$self}{qw( trn len o_r ot adc oadc ac mt amsg checksum )};
    }
};

eval q{
    package My::NetUCP;
    use Net::UCP;
    my $ucp = Net::UCP->new;
    sub new {
        my ($class, $str) = @_;
        my $self = $ucp->parse_message($str);
        return bless $self => $class;
    };
    sub as_string {
        my ($self) = @_;
        $ucp->{TRN_OBJ}->set_trn(99);
        return $ucp->make_message(%$self, op=>$self->{ot}, operation=>$self->{type}?1:0, trn=>0);
    };
};

use Protocol::EMIUCP::Message;

my $str_01 = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';
my $str_31 = '02/00035/O/31/0234765439845/0139/A0';

my %tests = (
    '1_Blessed' => sub {

        my $msg = My::Blessed->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    Moose->VERSION ? (
    '2_Moose' => sub {

        my $msg = My::Moose->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    '3_MooseImmutable' => sub {

        my $msg = My::MooseImmutable->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    ) : (),
    Mouse->VERSION ? (
    '4_Mouse' => sub {

        my $msg = My::Mouse->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    '5_MouseImmutable' => sub {

        my $msg = My::MouseImmutable->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    ) : (),
    Mo->VERSION ? (
    '6_Mo' => sub {

        my $msg = My::Mo->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    ) : (),
    VSO->VERSION ? (
    '7_VSO' => sub {

        my $msg = My::VSO->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    ) : (),
    Net::UCP->VERSION ? (
    '8_NetUCP' => sub {

        my $msg = My::NetUCP->new($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    ) : (),
    '9_EMIUCP_01' => sub {

        my $msg = Protocol::EMIUCP::Message->new_from_string($str_01);
        die $msg->as_string if $msg->as_string ne $str_01;

    },
    'A_EMIUCP_31' => sub {

        my $msg = Protocol::EMIUCP::Message->new_from_string($str_31);
        die $msg->as_string if $msg->as_string ne $str_31;

    },
    'B_EMIUCP_31_v' => sub {

        my $msg = Protocol::EMIUCP::Message->new_from_string($str_31)->validate;
        die $msg->as_string if $msg->as_string ne $str_31;

    },
);

use Benchmark ':all';

my $result = timethese($ARGV[0] || -1, { %tests });
cmpthese($result);
