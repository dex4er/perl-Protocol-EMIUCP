package Protocol::EMIUCP::OO;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(load_class);

use Exporter ();
our @EXPORT = qw( has extends with has_field );
BEGIN { *import = \&Exporter::import };

sub has ($) {
    my ($attrs) = @_;
    my $caller = caller();
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

sub has_field ($) {
    my ($attrs) = @_;

    my $caller = caller();
    my @roles = map { "Protocol::EMIUCP::Message::Role::Field::$_" }
        ref $attrs ? @$attrs : $attrs;

    @_ = @roles;
    goto &with;
};

1;
