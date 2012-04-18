package Protocol::EMIUCP::Message::Role::Field::Base::pid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

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

foreach my $code (keys %Value_To_Description) {
    my $name = $Value_To_Description{$code};
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Value{$name} = $code;
};

sub _import_base_pid {
    my ($class, $field, $args) = @_;

    foreach my $name (keys %Constant_To_Value) {
        my $code = uc($field) . '_' . $Constant_To_Value{$name};
        my $caller = $args->{caller};
        no strict 'refs';
        *{"${caller}::$name"} = sub () { $code };
    };
};

sub _build_base_pid_args {
    my ($class, $field, $args) = @_;

    my $uc_field = uc($field);

    $args->{$field} = $Constant_To_Value{$1}
        if defined $args->{$field} and $args->{$field} =~ /^${uc_field}_(.*)$/;

    return $class;
};

sub _validate_base_pid {
    my ($self, $field) = @_;

    my $validator = "list_valid_${field}_values";

    confess "Attribute ($field) is required"
        unless defined $self->{$field};
    confess "Attribute ($field) is invalid"
        unless grep { $_ eq $self->{$field} } @{ $self->$validator };

    return $self;
};

sub _base_pid_description {
    my ($self, $field, $code) = @_;
    return $Value_To_Description{ defined $code ? $code : $self->{$field} };
};

sub _build_base_pid_hashref {
    my ($self, $field, $hashref) = @_;

    my $field_description = "${field}_description";

    if (defined $hashref->{$field}) {
        $hashref->{$field_description} = $self->$field_description;
    };

    return $self;
};

1;
