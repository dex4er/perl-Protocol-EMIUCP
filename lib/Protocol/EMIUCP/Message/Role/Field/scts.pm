package Protocol::EMIUCP::Message::Role::Field::scts;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role::Field::Base::scts);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has load_class );

use constant field => do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has field;

eval { load_class('DateTime::Format::EMIUCP::' . uc(field)) };

my %Methods = (
    import_scts        => '_import_base_scts',
    build_scts_args    => '_build_base_scts_args',
    validate_scts      => '_validate_base_scts',
    scts_datetime      => '_base_scts_datetime',
    build_scts_hashref => '_build_base_scts_hashref',
);

while (my ($method, $base_method) = each %Methods) {
    no strict 'refs';
    *$method = sub {
        my ($self, @args) = @_;
        return $self->$base_method(field, @args);
    };
};

1;
