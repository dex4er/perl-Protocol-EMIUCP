#!/usr/bin/perl

=head1 NAME

emidecode - split EMI-UCP message fields without decoding

=head1 SYNOPSIS

B<emisplit> I<message>

Examples:

  $ emisplit 00/00070/O/51/507998000/123/////////////////3//54455354////
    /////////19

=head1 DESCRIPTION

This command splits the EMI-UCP message without validating and decoding each
field. It is possible to split the message which can be invalid, eg. with bad
C<checksum> or C<len>, wrong C<amg> field, etc.

=cut

use strict;
use warnings;

our $VERSION = '0.01';
use Protocol::EMIUCP;
use Data::Dumper ();

my $str = $ARGV[0] || die "Usage: $0 message\n";

my $fields = Protocol::EMIUCP->parse_message_from_string($str);

my $dump = Data::Dumper->new([ $fields ])
    ->Indent(1)
    ->Pair('=')
    ->Quotekeys(0)
    ->Sortkeys(1)
    ->Useqq(1)
    ->Terse(1)
    ->Dump;
$dump =~ s/^{\n(.*)\n}$/$1/s;
$dump =~ s/^\s\s(.*?),?$/$1/mg;
print $dump;

=head1 SEE ALSO

L<emiclient>, L<emiserver>, L<emiencode>, L<emidecode>,
L<http://github.com/dex4er/perl-Protocol-EMIUCP>.

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
