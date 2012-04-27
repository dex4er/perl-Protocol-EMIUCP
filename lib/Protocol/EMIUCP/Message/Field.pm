package Protocol::EMIUCP::Message::Field;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO ();

use Exporter qw(import);
our @EXPORT = qw(has_field);

sub has_field ($) {
    my ($attrs) = @_;

    my $caller = caller;
    my @roles = map { "Protocol::EMIUCP::Message::Role::Field::$_" }
        ref $attrs ? @$attrs : $attrs;

    @_ = @roles;
    goto &Protocol::EMIUCP::OO::with;
};

1;
