package Protocol::EMIUCP::Message::Role::Field::pwd;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

my $field = do { __PACKAGE__ =~ /^ .* :: (.*?) $/x; $1 };

has_field $field => (isa => 'EMIUCP_Hex16');

with qw(Protocol::EMIUCP::Message::Role::Field::Base::pwd);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    return $class->$orig( $class->_BUILDARGS_base_pwd($field, %args) );
};

sub pwd_utf8 {
    my ($self, $value) = @_;
    return $self->_base_pwd_utf8($field, $value);
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    $self->_make_hashref_base_pwd($field, $hashref);
};

1;
