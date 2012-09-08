package Protocol::EMIUCP::Session;

=head1 SYNOPSIS

  my $sess = Protocol::EMIUCP::Session(
      window   => 10,
      on_read  => \&cb,
      on_write => \&cb,
  );
  $sess->write_message($msg);

=cut

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message;
use Protocol::EMIUCP::Session::TRN;

with 'Protocol::EMIUCP::OO::Role::BuildArgs';

use Mouse::Util::TypeConstraints;

has 'login' => (
    isa       => 'EMIUCP_Num16',
    is        => 'ro',
);

has 'pwd' => (
    isa       => 'Str',
    is        => 'ro',
);

has 'o60' => (
    isa       => 'Protocom::EMIUCP::Message',
    is        => 'ro',
    predicate => 'has_o60',
    lazy      => 1,
    default   => sub { Protocol::EMIUCP::Message->new(
        o_r      => 'O',
        ot       => 60,
        oadc     => $_[0]->login,
        oton     => OTON_ABBREVIATED,
        onpi     => ONPI_PRIVATE,
        styp     => STYP_ADD_ITEM_TO_MO_LIST,
        pwd_utf8 => $_[0]->pwd,
        vers     => '0100',
    ) },
);

has 'on_read' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_read',
);

has 'on_write' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_write',
);

has 'on_timeout' => (
    isa       => 'CodeRef',
    is        => 'ro',
    predicate => 'has_on_timeout',
);

has '_trn_in' => (
    isa       => 'Protocol::EMIUCP::Session::TRN',
    is        => 'ro',
    default   => sub {
	my ($self) = @_;
	Protocol::EMIUCP::Session::TRN->new(
	    $self->_build_args,
	    on_timeout => sub { $self->_timeout_in(@_) },
	);
    },
);

has '_trn_out' => (
    isa       => 'Protocol::EMIUCP::Session::TRN',
    is        => 'ro',
    default   => sub {
	my ($self) = @_;
	Protocol::EMIUCP::Session::TRN->new(
	    $self->_build_args,
	    on_timeout => sub { $self->_timeout_out(@_) },
	);
    },
);

has '_msg_in' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

has '_msg_out' => (
    isa       => 'ArrayRef',
    is        => 'ro',
    default   => sub { [] },
);

sub write_message {
    my ($self, $msg) = @_;

    if ($msg->o_r eq 'O') {
	my $trn = $self->_trn_out->reserve;
	my $msg_with_trn = $msg->clone( trn => $trn );
	$self->_msg_out->[$trn] = $msg_with_trn;
	$self->on_write->($msg_with_trn);
    }
    else {
	$self->_trn_in->free($msg->trn);
	undef $self->_msg_in->[$msg->trn];
	$self->on_write->($msg);
    };
};

sub read_message {
    my ($self, $msg) = @_;

    if ($msg->o_r eq 'R') {
	$self->_trn_out->free($msg->trn);
	undef $self->_msg_out->[$msg->trn];
    }
    else {
	$self->_trn_in->reserve($msg->trn);
	$self->_msg_in->[$msg->trn] = $msg;
    };

    $self->on_read->($msg);
};

sub _timeout_in {
    my ($self, $trn) = @_;
    my $msg = $self->_msg_in->[$trn];

    return $self->on_timeout->(read => $msg) if ($self->has_on_timeout);

    my $rpl = $msg->new_response(
	nack => 1,
	ec   => EC_OPERATION_NOT_ALLOWED,
	sm   => ' Timeout for EMI-UCP operation',
    );
    $self->on_write->($rpl);
};

sub _timeout_out {
    my ($self, $trn) = @_;
    my $msg = $self->_msg_out->[$trn];

    return $self->on_timeout->(write => $msg) if ($self->has_on_timeout);

    my $rpl = $msg->new_response(
	nack => 1,
	ec   => EC_OPERATION_NOT_ALLOWED,
	sm   => ' Timeout for EMI-UCP operation',
    );
    $self->on_read->($rpl);
};

1;
