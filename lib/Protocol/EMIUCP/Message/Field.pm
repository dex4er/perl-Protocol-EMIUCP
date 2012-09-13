package Protocol::EMIUCP::Message::Field;

use strict;
use warnings;

our $VERSION = '0.01';

use Mouse::Exporter;

use Protocol::EMIUCP::Message::Types;
use Mouse::Util qw(apply_all_roles);

Mouse::Exporter->setup_import_methods(
    as_is => [qw( has_field required_field empty_field with_field )],
);

sub has_field {
    my ($name, %opts) = @_;

    my $meta = caller->meta;

    for my $n (ref $name ? @$name : $name) {
        $meta->add_attribute(
            $n,
            is        => 'ro',
            isa       => 'EMIUCP_Str',
            predicate => "has_$n",
            clearer   => "clear_$n",
            %opts,
        );
    };
};

sub required_field {
    my ($name, %opts) = @_;

    my $meta = caller->meta;

    for my $n (ref $name ? @$name : $name) {
        $meta->add_attribute(
            "+$n",
            required => 1,
            %opts,
        );
    };
};

sub empty_field {
    my ($name, %opts) = @_;

    my $meta = caller->meta;

    for my $n (ref $name ? @$name : $name) {
        $meta->add_attribute(
            "+$n",
            isa => 'EMIUCP_Nul',
            %opts,
        );
    };
};

sub with_field {
    my ($name, %opts) = @_;

    my @roles = map { $_ => { -excludes => [qw( import HAVE_DATETIME )] } }
        map { "Protocol::EMIUCP::Message::Role::Field::$_" }
        ref $name ? @$name : $name;

    my $caller = caller;
    apply_all_roles($caller, @roles);

    if (%opts) {
        my $meta = caller->meta;

        for my $n (ref $name ? @$name : $name) {
            $meta->add_attribute(
                "+$n",
                %opts,
            );
        };
    };
};

1;
