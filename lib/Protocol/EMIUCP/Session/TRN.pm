package Protocol::EMIUCP::Session::TRN;

=head1 SYNOPSIS

  my $trn = Protocol::EMIUCP::Session::TRN->new(
      on_timeout => sub { my ($trn) = @_; ... },
  );
  $trn->wait_for_free;

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;

use AnyEvent;
use Scalar::Util qw(weaken);

use Mouse::Util::TypeConstraints;

has 'timeout' => (
    isa       => subtype( as 'Num', where { $_ > 0 } ),
    is        => 'ro',
    default   => 15,
);

has 'message' => (
    does      => 'Protocol::EMIUCP::Message::Role',
    is        => 'ro',
    clearer   => 'clear_message',
);

has 'on_timeout' => (
    isa       => 'CodeRef',
    is        => 'rw',
    predicate => 'has_on_timeout',
    clearer   => 'clear_on_timeout',
);

has 'on_free' => (
    isa       => 'CodeRef',
    is        => 'rw',
    predicate => 'has_on_free',
    clearer   => 'clear_on_free',
);

has 'timer' => (
    is        => 'ro',
    clearer   => 'clear_timer',
    default   => sub {
        my ($self) = @_;
        weaken $self;
        AE::timer $self->timeout, 0, sub {
            AE::log debug => 'timer on_timeout %s', $self->message ? $self->message->as_string : '';
            $self->on_timeout->($self) if $self->has_on_timeout;
            $self->free;
        };
    },
);

has 'cv' => (
    is        => 'ro',
    clearer   => 'clear_cv',
    default   => sub { AE::cv },
);

sub free {
    my ($self) = @_;

    AE::log debug => 'free %s', $self->message ? $self->message->as_string : '';

    $self->on_free->($self) if $self->has_on_free;
    $self->clear_timer;
    $self->clear_message;
    $self->cv->send;

    AE::log debug => 'free send %s', $self->message ? $self->message->as_string : '';
};

sub wait_for_free {
    my ($self) = @_;

    AE::log debug => 'wait_for_free %s', $self->message ? $self->message->as_string : '';
    return unless $self->cv;

    $self->cv->recv;

    AE::log debug => 'wait_for_free recv %s', $self->message ? $self->message->as_string : '';
};

sub DEMOLISH {
    my ($self) = @_;
    AE::log debug => 'DEMOLISH %s', $self->message ? $self->message->as_string : '';
    $self->free;
};

1;
