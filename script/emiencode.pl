#!/usr/bin/perl

=head1 NAME

emiencode - encoder of EMI-UCP message

=head1 SYNOPSIS

B<emiencode> I<message>

Examples:

  $ emiencode o=1 ot=51 adc=507998000 oadc=123 mt=3 amsg_utf8="TEST"

=head1 DESCRIPTION

This command creates the EMI-UCP message from separate fields. This is a
reverse of L<emidecode> command.

Some fields can be given in different form, eg. C<amsg> field can be given as
GSM 03.38 hex string (C<amsg=5445535>) or UTF-8 text string
(C<amsg_utf8=TEST>).

=cut

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP;

die "Usage: $0 field=value field=value\n" unless @ARGV;

my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } @ARGV;

my $msg = Protocol::EMIUCP->new_message(%fields);

print $msg->as_string, "\n";

=head1 SEE ALSO

L<emiclient>, L<emiserver>, L<emidecode>, L<emisplit>,
L<http://github.com/dex4er/perl-Protocol-EMIUCP>.

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
