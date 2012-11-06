package Protocol::EMIUCP;

=head1 NAME

Protocol::EMIUCP - Library for EMI-UCP protocol

=head1 SYNOPSIS

  use Protocol::EMIUCP;
  my $msg = Protocol::EMIUCP->new_message(
      o => 1, ot => 51, adc => 507998000, oadc => 6638,
      mt => 3, amsg_utf8 => 'TEST',
  );
  print $msg->as_string;

=head1 DESCRIPTION

This is a library for EMI-UCP protocol which is primarily used to connect to
short message service centers (SMSCs) for mobile telephones.

The library provides an API for handling EMI-UCP messages and connections as
client or server.

The B<Protocol::EMIUCP> package joins a few more pacakges in one factory
class.

=for readme stop

=cut

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';


use Protocol::EMIUCP::Message;


sub new_message {
    my ($class, %args) = @_;
    Protocol::EMIUCP::Message->new(%args);
};

sub new_message_from_string {
    my ($class, $str) = @_;
    Protocol::EMIUCP::Message->new_from_string($str);
};

sub parse_message_from_string {
    my ($class, $str) = @_;
    Protocol::EMIUCP::Message->parse_string($str);
};


1;


=for readme continue

=head1 INSTALLING

=head2 Windows

Download the Perl runtime environment, eg. L<http://strawberryperl.com/> and install additional modules:

  C:\> cpanm POSIX::strftime::GNU
  C:\> cpanm https://github.com/downloads/dex4er/perl-Protocol-EMIUCP/Protocol-EMIUCP-0.01-20121106-2.tar.gz

=head2 Ubuntu

Install additional modules:

  $ sudo apt-get install libanyevent-perl libmousex-strictconstructor-perl
  $ sudo apt-get install liblocal-lib-perl cpanm
  $ cpanm https://github.com/downloads/dex4er/perl-Protocol-EMIUCP/Protocol-EMIUCP-0.01-20121106-2.tar.gz

Set up environment:

  $ export PERL5LIB=~/perl5/lib/perl5
  $ export PATH=~/perl5/bin:$PATH

=head1 SEE ALSO

L<emiclient>, L<emiserver>, L<emiencode>, L<emidecode>, L<emisplit>,
L<Protocol::EMIUCP::Message>, L<http://en.wikipedia.org/wiki/EMI_(protocol)>

=head1 BUGS

If you find the bug or want to implement new features, please report it at
L<https://github.com/dex4er/perl-Protocol-EMIUCP/issues>

The code repository is available at
L<http://github.com/dex4er/perl-Protocol-EMIUCP>

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
