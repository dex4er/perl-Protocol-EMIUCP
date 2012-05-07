package Protocol::EMIUCP::Message::Role::Field::Base::pwd;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Encode qw( from_hex_to_utf8 from_utf8_to_hex );

sub _BUILDARGS_base_pwd {
    my ($class, $field, %args) = @_;

    my $field_utf8 = "${field}_utf8";
    $args{$field} = from_utf8_to_hex delete $args{$field_utf8}
        if defined $args{$field_utf8};

    return %args;
};

sub _base_pwd_utf8 {
    my ($self, $field) = @_;
    return from_hex_to_utf8 $self->{$field}
};

sub _make_hashref_base_pwd {
    my ($self, $field, $hashref) = @_;
    my $field_utf8 = "${field}_utf8";
    $hashref->{$field_utf8} = $self->$field_utf8 if defined $hashref->{$field};
};

1;
