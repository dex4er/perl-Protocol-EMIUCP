package Protocol::EMIUCP::Message::Role::Field::dscts;

use Mouse::Role;

use Protocol::EMIUCP::Message::Field;

has_field 'dscts' => (isa => 'EMIUCP_Num_12');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::DSCTS };

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{dscts} = DateTime::Format::EMIUCP::DSCTS->format_datetime($args{dscts})
        if blessed $args{dscts} and $args{dscts}->isa('DateTime');

    return $class->$orig(%args);
};

sub dscts_datetime {
    my ($self) = @_;

    return unless defined $self->{dscts};

    return DateTime::Format::EMIUCP::DSCTS->parse_datetime($self->{dscts});
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;

    $hashref->{dscts_datetime} = $self->dscts_datetime->datetime
        if HAVE_DATETIME and defined $hashref->{dscts};

    return $self;
};

1;
