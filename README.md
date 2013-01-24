# NAME

Protocol::EMIUCP - Library for EMI-UCP protocol

# SYNOPSIS

    use Protocol::EMIUCP;
    my $msg = Protocol::EMIUCP->new_message(
        o => 1, ot => 51, adc => 507998000, oadc => 6638,
        mt => 3, amsg_utf8 => 'TEST',
    );
    print $msg->as_string;

# DESCRIPTION

This is a library for EMI-UCP protocol which is primarily used to connect to
short message service centers (SMSCs) for mobile telephones.

The library provides an API for handling EMI-UCP messages and connections as
client or server.

The __Protocol::EMIUCP__ package joins a few more pacakges in one factory
class.

# INSTALLING

## Windows

Download the Perl runtime environment, eg. [http://strawberryperl.com/](http://strawberryperl.com/) and install additional modules:

    C:\> cpanm POSIX::strftime::GNU
    C:\> cpanm https://github.com/downloads/dex4er/perl-Protocol-EMIUCP/Protocol-EMIUCP-0.01-20121106-2.tar.gz

## Ubuntu

Install additional modules:

    $ sudo apt-get install libanyevent-perl libmousex-strictconstructor-perl
    $ sudo apt-get install liblocal-lib-perl cpanminus
    $ cpanm https://github.com/downloads/dex4er/perl-Protocol-EMIUCP/archive/20130124-1.tar.gz

Set up environment:

    $ export PERL5LIB=~/perl5/lib/perl5
    $ export PATH=~/perl5/bin:$PATH

# SEE ALSO

[emiclient](http://search.cpan.org/perldoc?emiclient), [emiserver](http://search.cpan.org/perldoc?emiserver), [emiencode](http://search.cpan.org/perldoc?emiencode), [emidecode](http://search.cpan.org/perldoc?emidecode), [emisplit](http://search.cpan.org/perldoc?emisplit),
[Protocol::EMIUCP::Message](http://search.cpan.org/perldoc?Protocol::EMIUCP::Message), [http://en.wikipedia.org/wiki/EMI\_(protocol)](http://en.wikipedia.org/wiki/EMI\_(protocol))

# BUGS

If you find the bug or want to implement new features, please report it at
[https://github.com/dex4er/perl-Protocol-EMIUCP/issues](https://github.com/dex4er/perl-Protocol-EMIUCP/issues)

The code repository is available at
[http://github.com/dex4er/perl-Protocol-EMIUCP](http://github.com/dex4er/perl-Protocol-EMIUCP)

# AUTHOR

Piotr Roszatycki <dexter@cpan.org>

# LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See [http://dev.perl.org/licenses/artistic.html](http://dev.perl.org/licenses/artistic.html)
