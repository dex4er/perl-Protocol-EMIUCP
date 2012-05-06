package Protocol::EMIUCP::Message::Role::Field::Base::pid;

use Mouse::Role;

our $VERSION = '0.01';

my %Constant_To_Value;

my %Value_To_Description = (
    '0100' => 'Mobile Station',
    '0122' => 'Fax Group 3',
    '0131' => 'X.400',
    '0138' => 'Menu over PSTN',
    '0139' => 'PC via PSTN',
    '0339' => 'PC via X.25',
    '0439' => 'PC via ISDN',
    '0539' => 'PC via TCP/IP',
    '0639' => 'PC via Abbreviated Number',
);

while (my ($value, $name) = each %Value_To_Description) {
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $value;
};

sub _import_base_pid {
    my ($class, $field, %args) = @_;

    my $uc_field = uc($field);
    my $caller = $args{caller} || caller(1);

    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::${uc_field}_$name"} = sub () { $value };
    };
};

sub _BUILD_base_pid {
    my ($self, $field) = @_;

    my $validator = "list_valid_${field}_values";

    confess "Attribute ($field) is invalid"
        if defined $self->{$field} and not grep { $_ eq $self->{$field} } @{ $self->$validator };
};

sub _base_pid_description {
    my ($self, $field, $value) = @_;
    return $Value_To_Description{ defined $value ? $value : $self->{$field} };
};

sub _make_hashref_base_pid {
    my ($self, $field, $hashref) = @_;

    my $field_description = "${field}_description";

    if (defined $hashref->{$field}) {
        $hashref->{$field_description} = $self->$field_description;
    };
};

1;
