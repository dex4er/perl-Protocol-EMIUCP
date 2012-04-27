package Protocol::EMIUCP::OO;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(load_class);
use Protocol::EMIUCP::OO::Object ();

use Exporter ();
our @EXPORT = qw( has extends with );

sub import {
    {
        my $caller = caller;

        no strict 'refs';
        no warnings 'once';
        push @{ *{"${caller}::ISA"} }, __PACKAGE__ . '::Object';
    }
    goto &Exporter::import;
};

sub has ($) {
    my ($attrs) = @_;
    my $caller = caller;
    no strict 'refs';
    foreach my $name (ref $attrs ? @$attrs : $attrs) {
        *{"${caller}::$name"}     = sub { $_[0]->{$name} };
        *{"${caller}::has_$name"} = sub { exists $_[0]->{$name} };
    };
};

sub extends (@) {
    my (@classes) = @_;
    my $caller = caller;

    no strict 'refs';
    no warnings 'once';
    foreach my $class (@classes) {
        load_class($class);
        push @{ *{"${caller}::ISA"} }, $class;
    };
};

sub with (@) {
    my (@roles) = @_;
    my $caller = caller;

    no strict 'refs';
    no warnings 'once';
    foreach my $role (@roles) {
        load_class($role);
        push @{ *{"${caller}::ISA"} }, $role;
        push @{ *{"${caller}::DOES"} }, $role;
    };
};

1;
