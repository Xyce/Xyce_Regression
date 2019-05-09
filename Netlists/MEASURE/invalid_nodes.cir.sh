#!/usr/bin/env perl

use XyceRegression::Tools;
$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script  (This is NEVER used and can be ignored)
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

use Getopt::Long;
&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3]; 
$GOLDPRN=$ARGV[4];

if (defined($verbose)) { $Tools->setVerbose(1); }

# Check various error cases.
# These strings should be in the output of this failed Xyce run.
# Note that parens are escaped with \\
@searchstrings = ("Netlist error: Function or variable V\\(\\)\\) is not defined",
     "Netlist error: Function or variable V\\(BOGONODE\\) is not defined",
     "Netlist error: Function or variable N\\(MISSINGNODE\\) is not defined",
     "Netlist error: Function or variable V\\(GND\\) is not defined"
 );

$retval = $Tools->runAndCheckError($CIRFILE,$XYCE,@searchstrings);
print "Exit code = $retval\n"; exit $retval; 
