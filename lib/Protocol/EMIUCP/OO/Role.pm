package Protocol::EMIUCP::OO::Role;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

use Protocol::EMIUCP::Util qw(get_linear_isa);

use Exporter ();
our @EXPORT = qw( has extends with has_field does );
BEGIN { *import = \&Exporter::import };

sub does ($$) {
    my ($self, $role) = @_;
    my $class = ref $self ? ref $self : $self;

    no strict 'refs';
    my @does = @{"${class}::DOES"};

    return '' unless @does;
    return !! grep { $_ eq $role } map { @{ get_linear_isa $_ } } @does;
};

1;
