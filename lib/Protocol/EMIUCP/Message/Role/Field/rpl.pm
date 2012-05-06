package Protocol::EMIUCP::Message::Role::Field::rpl;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum 'EMIUCP_RPl' => [qw( 1 2 )];

use Protocol::EMIUCP::Message::Field;

has_field 'rpl' => (isa => 'EMIUCP_RPl');

my %Constant_To_Value;

my %Value_To_Description = (
    '1' => 'Request',
    '2' => 'Response',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $Constant_To_Value{$name} = $value;
};

sub import {
    my ($class, %args) = @_;
    my $caller = $args{caller} || caller;
    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::RPL_$name"} = sub () { $value };
    };
};

sub rpl_description {
    my ($self, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{rpl} };
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{rpl}) {
        $hashref->{rpl_description} = $self->rpl_description;
    };
};

1;
