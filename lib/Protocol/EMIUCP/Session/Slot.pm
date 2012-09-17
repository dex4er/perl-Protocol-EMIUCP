package Protocol::EMIUCP::Session::Slot;

=head1 SYNOPSIS

  my $slot = Protocol::EMIUCP::Session::Slot->new(
      on_timeout => sub { my ($slot) = @_; ... },
  );
  $slot->wait_for_free;

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
    is        => 'rw',
    predicate => '_has_message',
    clearer   => '_clear_message',
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
    predicate => '_has_timer',
    clearer   => '_clear_timer',
    default   => sub {
        my ($self) = @_;
        weaken $self;
        AE::timer $self->timeout, 0, sub {
            AE::log debug => 'timer on_timeout %s', $self->message ? $self->message->as_string : '';
            $self->on_timeout->($self) if $self->has_on_timeout;
            $self->free if defined $self;
        };
    },
);

has 'cv' => (
    is        => 'ro',
    default   => sub { AE::cv },
);

sub free {
    my ($self) = @_;

    AE::log debug => 'free %s', $self->message ? $self->message->as_string : '';
    return unless $self->_has_timer;

    $self->on_free->($self) if $self->has_on_free;
    $self->cv->send;
    $self->_clear_timer;
    $self->_clear_message;

    AE::log debug => 'free finished %s', $self->message ? $self->message->as_string : '';
};

sub wait_for_free {
    my ($self) = @_;

    AE::log debug => 'wait_for_free %s', $self->message ? $self->message->as_string : '';

    $self->cv->recv;

    AE::log debug => 'wait_for_free recv %s', $self->message ? $self->message->as_string : '';
};

sub DEMOLISH {
    my ($self) = @_;
    AE::log debug => 'DEMOLISH %s', $self->message ? $self->message->as_string : '';
    warn "DEMOLISH $self" if defined ${^GLOBAL_PHASE} and ${^GLOBAL_PHASE} eq 'DESTRUCT';
    $self->free;
};

1;
