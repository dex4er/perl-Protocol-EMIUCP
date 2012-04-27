package Protocol::EMIUCP::OO::Object;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO ();

use Protocol::EMIUCP::Util qw(get_linear_isa);
eval { require Data::Dumper };

sub new {
    my ($class, %args) = @_;

    $class->_build_args(\%args);

    my $self = { %args };
    return bless $self => $class;
};

sub _build_args {
    my ($class, $args) = @_;

    $class->$_($args) foreach grep { $class->can($_) }
        map { /::(\w+)$/; '_build_args_' . lc $1 } @{ $class->_list_roles };

    return $class;
};

sub _list_roles {
    my ($self) = @_;

    no strict 'refs';
    my $class = ref $self ? ref $self : $self;

    return [
        grep { $_->can('does') and $_->does('Protocol::EMIUCP::OO::Role') }
            @{ get_linear_isa $class }
    ];
};

sub dump {
    my ($self) = @_;
    Data::Dumper->Dump([ $self ]);
};

1;
