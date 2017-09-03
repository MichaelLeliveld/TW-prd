#!/usr/bin/perl

use Math::Round;

round(10.2) == 10 || die "round(10.2) != 10";

print "Content-type: text/html\n\n";
print <<EOF
<html>
<head><title>MIKE: Everything is OK</title></head>
<body>
<H1>Here from MIKE</H1>
Everything is very newest and fine.
</body>
</html>
EOF
;