package Protocol::EMIUCP::Message::Role::Field::ddt;

use Mouse::Role;

use Protocol::EMIUCP::Message::Field;

has_field 'ddt' => (isa => 'EMIUCP_Num_10');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::DDT };

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{ddt} = DateTime::Format::EMIUCP::DDT->format_datetime($args{ddt})
        if blessed $args{ddt} and $args{ddt}->isa('DateTime');

    return $class->$orig(%args);
};

sub ddt_datetime {
    my ($self) = @_;

    return unless defined $self->{ddt};

    return DateTime::Format::EMIUCP::DDT->parse_datetime($self->{ddt});
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;

    $hashref->{ddt_datetime} = $self->ddt_datetime->datetime
        if HAVE_DATETIME and defined $hashref->{ddt};

    return $self;
};

1;
