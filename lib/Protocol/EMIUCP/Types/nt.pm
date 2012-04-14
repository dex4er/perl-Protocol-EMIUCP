package Protocol::EMIUCP::Types::nt;

use 5.006;

our $VERSION = '0.01';


use Moose;
use Moose::Util::TypeConstraints;

use constant::boolean;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

our %NT_To_Message = (
    1 => 'BN',
    2 => 'DN',
    4 => 'ND',
);

our %Message_To_NT = reverse %NT_To_Message;

use constant ();

my @NT_constants;
foreach (keys %Message_To_NT) {
    my $name = 'NT_' . $_;
    $name =~ tr/a-z/A-Z/;
    push @NT_constants, $name;
    constant->import($name => $Message_To_NT{$_});
};

use Exporter ();
our @EXPORT = @NT_constants;
BEGIN { *import = \&Exporter::import; }

use Protocol::EMIUCP::Types;

coerce 'Protocol::EMIUCP::Types::nt'
    => from Any
    => via { Protocol::EMIUCP::Types::nt->new( value => $_ ) };

has value => (is => 'ro', isa => 'EMIUCP_NT', required => 1);

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub as_message {
    my ($self) = @_;
    my $v = $self->value;
    return join '+', grep { $_ } map { $NT_To_Message{$v & $_} } reverse keys %NT_To_Message;
};

foreach my $nt (keys %Message_To_NT) {
    __PACKAGE__->meta->add_method("is_" . lc($nt) => sub {
        my ($self) = @_;
        return $self->value & $Message_To_NT{$nt} ? TRUE : FALSE;
    });
};


__PACKAGE__->meta->make_immutable();

1;
