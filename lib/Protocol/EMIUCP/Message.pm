package Protocol::EMIUCP::Message;

use 5.008;

our $VERSION = '0.01';


# Factory class

use Moose;

use Protocol::EMIUCP::Util qw(SEP);


sub _find_new_class_from_args {
    my ($class, %args) = @_;

    no warnings 'numeric';
    confess 'OT is required'  unless defined $args{ot}  and $args{ot} > 0;
    confess 'O_R is required' unless defined $args{o_r} and $args{o_r} =~ /^[OR]$/;
    confess 'ACK or NACK is required if O_R is "R"' if $args{o_r} eq 'R' and not $args{ack} || $args{nack};

    my $new_class = sprintf 'Protocol::EMIUCP::Message::%s_%02d', $args{o_r}, $args{ot};
    if (defined $args{ack}) {
        $new_class .= '_A';
    };
    if (defined $args{nack}) {
        confess 'Both ACK and NACK are defined' if defined $args{ack};
        $new_class .= '_N';
    };

    Class::MOP::load_class($new_class);
    return $new_class;
};


sub _find_new_class_from_string {
    my ($class, $str) = @_;
    my @fields = split SEP, $str;
    my %args = (
        o_r => $fields[2],
        ot  => $fields[3],
    );
    if ($args{o_r} eq 'R' and defined $fields[4]) {
        $args{ack}  = 'A' if $fields[4] eq 'A';
        $args{nack} = 'N' if $fields[4] eq 'N';
    };

    return $class->_find_new_class_from_args(%args);
};


sub new {
    my ($class, %args) = @_;
    $class->_find_new_class_from_args(%args)->new(%args);
};


sub new_from_string {
    my ($class, $str) = @_;
    $class->_find_new_class_from_string($str)->new_from_string($str);
};


1;
