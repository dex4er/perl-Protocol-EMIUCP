package Protocol::EMIUCP::Message::Role::Field::Base::pid;

use Moose::Role;

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

use Moose::Util::TypeConstraints;

enum 'EMIUCP_PID' => [ keys %Value_To_Description ];

sub _import_base_pid {
    my ($class, $field, %args) = @_;

    my $uc_field = uc($field);
    my $caller = $args{caller} || caller(1);

    while (my ($name, $value) = each %Constant_To_Value) {
        no strict 'refs';
        *{"${caller}::${uc_field}_$name"} = sub () { $value };
    };
};

sub _base_pid_description {
    my ($self, $field) = @_;
    return defined $self->{$field} ? $Value_To_Description{ $self->{$field} } : undef;
};

1;
