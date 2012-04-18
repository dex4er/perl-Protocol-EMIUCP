package Protocol::EMIUCP::Message::Field::Base::pid;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

my %Constant_To_Code;

my %Code_To_Message = (
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

foreach my $code (keys %Code_To_Message) {
    my $name = $Code_To_Message{$code};
    $name =~ tr/a-z/A-Z/;
    $name =~ s/\W/_/g;
    $Constant_To_Code{$name} = $code;
};

sub _import_base_pid {
    my ($class, $field, $args) = @_;

    foreach my $name (keys %Constant_To_Code) {
        my $code = uc($field) . '_' . $Constant_To_Code{$name};
        my $caller = $args->{caller};
        no strict 'refs';
        *{"${caller}::$name"} = sub () { $code };
    };
};

sub _build_base_pid_args {
    my ($class, $field, $args) = @_;

    my $uc_field = uc($field);

    $args->{$field} = $Constant_To_Code{$1}
        if defined $args->{$field} and $args->{$field} =~ /^${uc_field}_(.*)$/;

    return $class;
};

sub _validate_base_pid {
    my ($self, $field) = @_;

    my $validator = "list_valid_${field}_codes";

    confess "Attribute ($field) is required"
        unless defined $self->{$field};
    confess "Attribute ($field) is invalid"
        unless grep { $_ eq $self->{$field} } @{ $self->$validator };

    return $self;
};

sub _base_pid_message {
    my ($self, $field, $code) = @_;
    return $Code_To_Message{ defined $code ? $code : $self->{$field} };
};

sub _build_base_pid_hashref {
    my ($self, $field, $hashref) = @_;

    my $field_message = "${field}_message";

    if (defined $hashref->{$field}) {
        $hashref->{$field_message} = $self->$field_message;
    };

    return $self;
};

1;
