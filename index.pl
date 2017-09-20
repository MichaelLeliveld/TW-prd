#!/usr/bin/perl

use CGI;
use LWP::UserAgent;
use LWP::Protocol::https;

print "Content-type: text/html\n\n";

my %pars     = CGI::Vars();
my $user     = $pars{user};
my $password = $pars{password};
if ( defined($user) && defined($password) ) {
	my $ua   = LWP::UserAgent->new();
	my $host = "tradewatch.hopto.org";
	my $url  = "http://$host/index.pl";
	$ua->credentials( "$host:80", 'TradeWatch', $user, $password );

	my $response = undef;
	eval { $response = $ua->get($url); };
	ysloaderMonitoring::error($@) if $@;
	if ( $response->is_success ) {
		## foreach my $line ( split( /\n/, $response->decoded_content ) ) {
		## }
		print $response->decoded_content;
	}
	else {
		print "<H2>Can't get the page</H2>";
		print "Error: " . $response->status_line;
	}
}
else {
	print "<H2>Access denied!</H2>";
}

exit 0;
