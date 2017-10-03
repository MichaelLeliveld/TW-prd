#!/usr/bin/perl

use strict;
use warnings;

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

use CGI;
use LWP::UserAgent;
use LWP::Protocol::https;

print "Content-type: text/html\n\n";

my %pars     = CGI::Vars();
my $user     = $pars{user};
my $password = $pars{password};
my $path     = $pars{path};
$path = 'index.pl' unless defined($path);
my $dir = $path;
$dir =~ s/[^\/]+$//;

if ( defined($user) && defined($password) ) {
	my $ua          = LWP::UserAgent->new();
	my $host        = "tradewatch.hopto.org";
	my $url         = "https://$host/$path";
	my $thisHost    = 'prd-aml-tradewatch.7e14.starter-us-west-2.openshiftapps.com';
	# my $thisUrl     = "https://$thisHost/?path=$dir";
	my $thisUrl     = "?path=$dir";
	my $credentials = "&user=$user&password=$password";

	$ua->credentials( "$host:443", 'TradeWatch', $user, $password );

	my $input = "<input type=\"hidden\" name=\"user\" value=\"$user\" id=\"user\" />\n";
	$input .= "<input type=\"hidden\" name=\"password\" value=\"$password\" id=\"password\" />\n";
	$input .= "<input type=\"hidden\" name=\"path\" value=\"$path\" id=\"path\" />\n";
	my $response = undef;
	eval { $response = $ua->get($url); };
	ysloaderMonitoring::error($@) if $@;
	if ( $response->is_success ) {
		my $html = $response->decoded_content;
		$html =~ s/<[Hh][Ee][Aa][Dd]>/<head>\n  <link rel=\"icon\" href=\"\/favicon.ico\">/;
		$html =~ s/<\s*[Aa]\s+[Hh][Rr][Ee][Ff]=\"([^>]+)\"\s*>/<a href=\"$thisUrl$1$credentials\">/sg;
		$html =~ s/<form([^>]+) action=\"([^\"]*)\?([^\"]*)\"/<form$1 action=\"$2&$3\"/sg;
		$html =~ s/<form([^>]+) action=\"([^\"]+)\"/<form$1 action=\"$thisUrl$2$credentials\"/sg;
		$html =~ s/<\/form>/$input\n<\/form>/sg;
		print $html;
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
