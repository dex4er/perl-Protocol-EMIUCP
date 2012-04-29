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

    load_class($_) foreach (@classes);

    no strict 'refs';
    no warnings 'once';
    my @isa = @{ *{"${caller}::ISA"} };
    @{ *{"${caller}::ISA"} } = (@classes, @isa);
};

sub with (@) {
    my (@roles) = @_;
    my $caller = caller;

    load_class($_) foreach (@roles);

    no strict 'refs';
    no warnings 'once';
    my @isa = @{ *{"${caller}::ISA"} };
    @{ *{"${caller}::ISA"} } = (@roles, @isa);
    my @does = @{ *{"${caller}::DOES"} };
    @{ *{"${caller}::DOES"} } = (@roles, @does);
};

1;
