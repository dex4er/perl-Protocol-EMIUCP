package Protocol::EMIUCP::Message::Field::pid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

my %Constant_To_PID;
my %PID_To_Message = (
    '0100' => 'Mobile Station',
    '0122' => 'Fax Group 3',
    '0131' => 'X.400',
    '0138' => 'Menu over PSTN',
    '0139' => 'PC via PSTN',
    '0339' => 'PC via X.25',
    '0439' => 'PC via ISDN',
    '0539' => 'PC via TCP/IP',
    '0639' => 'PC via Abbreviated Number',
);

foreach my $pid (keys %PID_To_Message) {
    my $name = 'PID_' . $PID_To_Message{$pid};
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W+/_/g;
    $Constant_To_PID{$name} = $pid;
};

sub import {
    foreach my $name (keys %Constant_To_PID) {
        my $pid = $Constant_To_PID{$name};
        my $caller = caller();
        no strict 'refs';
        *{"${caller}::$name"} = sub () { $pid };
    };
};

sub build_pid_args {
    my ($class, $args) = @_;

    $args->{pid} = $Constant_To_PID{ $args->{pid} }
        if defined $args->{pid} and $args->{pid} =~ /^PID_/;

    return $class;
};

sub validate_pid {
    my ($self) = @_;

    confess "Attribute (pid) is required"
        unless defined $self->{pid};
    confess "Attribute (pid) is invalid"
        unless grep { $_ eq $self->{pid} } $self->list_pid_codes;

    return $self;
};

sub list_pid_codes {
    confess "Method (list_pid_codes) have to be overrided by derived class method";
};

sub pid_message {
    my ($self, $pid) = @_;
    return $PID_To_Message{ defined $pid ? $pid : $self->{pid} };
};

sub build_pid_hashref {
    my ($self, $hashref) = @_;
    if (defined $hashref->{pid}) {
        $hashref->{pid_message} = $self->pid_message;
    };
    return $self;
};


1;
