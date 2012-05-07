package Protocol::EMIUCP::Message::Role::Field::scts;

use Moose::Role;

use Protocol::EMIUCP::Message::Field;

has_field 'scts' => (isa => 'EMIUCP_Num_12');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{scts} = DateTime::Format::EMIUCP::SCTS->format_datetime($args{scts})
        if blessed $args{scts} and $args{scts}->isa('DateTime');

    return $class->$orig(%args);
};

sub scts_datetime {
    my ($self) = @_;

    return unless defined $self->{scts};

    return DateTime::Format::EMIUCP::SCTS->parse_datetime($self->{scts});
};

after _make_hashref => sub {
    my ($self, $hashref) = @_;

    $hashref->{scts_datetime} = $self->scts_datetime->datetime
        if HAVE_DATETIME and defined $hashref->{scts};

    return $self;
};

1;
