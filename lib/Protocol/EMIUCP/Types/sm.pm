package Protocol::EMIUCP::Types::sm;

use 5.008;

our $VERSION = '0.01';


use Moose;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Types::scts;

use DateTime;

use Protocol::EMIUCP::Field;

has_field 'adc';

has scts => (
    is       => 'ro',
    isa      => 'Protocol::EMIUCP::Types::scts',
    coerce   => 1,
    required => 1,
    default  => sub { DateTime->now },
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
