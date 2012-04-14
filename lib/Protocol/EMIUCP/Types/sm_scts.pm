package Protocol::EMIUCP::Types::sm_scts;

use 5.006;

our $VERSION = '0.01';


use Moose;
use Moose::Util::TypeConstraints;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Types::scts;

use Protocol::EMIUCP::Field;

use DateTime;

coerce 'Protocol::EMIUCP::Types::sm_scts'
    => from Any
    => via { Protocol::EMIUCP::Types::sm_scts->new( value => $_ ) };

has_field 'adc';

has scts => (
    is       => 'ro',
    isa      => 'Protocol::EMIUCP::Types::scts',
    coerce   => 1,
    required => 1,
    default  => sub { DateTime->now },
    handles  => {
        scts_as_string => 'as_string',
    },
);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{value} and $args{value} =~ /^(\d*):(\d*)$/) {
        @args{qw( adc scts )} = ($1, $2);
    };
    return $class->$orig(%args);
};

sub as_string {
    my ($self) = @_;
    return sprintf '%s:%s', $self->adc, $self->scts;
};


__PACKAGE__->meta->make_immutable();

1;
