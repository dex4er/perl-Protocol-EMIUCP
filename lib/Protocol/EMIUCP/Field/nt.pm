package Protocol::EMIUCP::Field::nt;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::nt;
use Protocol::EMIUCP::Field;

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (not ref ($args{nt} || '')) {
        no warnings 'numeric';
        my $nt = $args{nt} || 0;
        $nt |= NT_BN if $args{nt_is_bn};
        $nt |= NT_DN if $args{nt_is_dn};
        $nt |= NT_ND if $args{nt_is_nd};
        $args{nt} = Protocol::EMIUCP::Types::nt->new(
            value => $nt,
        );
    };
    return $class->$orig(%args);
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{nt}) {
        $hashref->{nt}         = $self->nt_string;
        $hashref->{nt_message} = $self->nt_message;
        foreach (qw( nt_is_bn nt_is_dn nt_is_nd )) {
            my $value = $self->$_;
            $hashref->{$_} = $value if $value;
        };
    };
    return $hashref;
};


1;
