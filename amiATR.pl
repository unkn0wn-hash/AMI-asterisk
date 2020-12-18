#!/usr/bin/env perl

use strict;
use warnings;
use Asterisk::AMI;

my $data = 'campains';
open(my $data_lines,'<:encoding(UTF-8)',$data)
	or die "No file found '$data' $!";

my $astman = Asterisk::AMI->new(PeerAddr => '127.0.0.1',
	PeerPort => '5038',
	Username => 'admin',
	Secret => 'superpass'
);

die "Unable to connect to asterisk" unless ($astman);

while (my $row = <$data_lines>) {
	chomp $row;
	my $ext = "31$row";
	my $channel = "Local/$ext\@queue-handle";
	my $response = $astman->action({Action => 'Originate',
	Channel => "$channel",
	Context => 'sip-handle-auto',
	CallerID => 'OPERATOR',
	Exten => "$ext",
	Priority => 1});
}

# my $response = $astman->action({Action => 'Originate',
# Channel => 'Local/310937@queue-handle',
# Context => 'sip-handle-docker',
# CallerID => 'OPERATOR',
# Exten => 310937,
# Priority => 1});
