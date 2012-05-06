package Protocol::EMIUCP::Message::Role::Field::vp;

use Mouse::Role;

use Protocol::EMIUCP::Message::Field;

has_field 'vp' => (isa => 'EMIUCP_Num_10');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::VP };

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{vp} = DateTime::Format::EMIUCP::VP->format_datetime($args{vp})
        if blessed $args{vp} and $args{vp}->isa('DateTime');

    return $class->$orig(%args);
};

sub vp_datetime {
    my ($self) = @_;

    return unless defined $self->{vp};

    return DateTime::Format::EMIUCP::VP->parse_datetime($self->{vp});
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;

    $hashref->{vp_datetime} = $self->vp_datetime->datetime
        if HAVE_DATETIME and defined $hashref->{vp};

    return $self;
};

1;
