#!/usr/bin/perl

=head1 NAME

emidecode - decoder of EMI-UCP message

=head1 SYNOPSIS

B<emidecode> I<message>

Examples:

  $ emidecode 00/00070/O/51/507998000/123/////////////////3//54455354///
  //////////19

=head1 DESCRIPTION

This command validates and decodes the EMI-UCP message. This is a reverse of
L<emiencode> command.

=cut

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP;
use Data::Dumper ();

my $str = $ARGV[0] || die "Usage: $0 message\n";

my $msg = Protocol::EMIUCP->new_message_from_string($str);

my $dump = Data::Dumper->new([ $msg->as_hashref ])
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

L<emiclient>, L<emiserver>, L<emiencode>, L<emisplit>,
L<http://github.com/dex4er/perl-Protocol-EMIUCP>.

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
