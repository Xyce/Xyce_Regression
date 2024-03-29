#!/usr/bin/env perl

use XyceRegression::Tools;
$Tools = XyceRegression::Tools->new();

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script  (This is NEVER used and can be ignored)
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3]; 

$REMEASPRN="$CIRFILE.remeas.prn";

# remove files from previous runs
system("rm -f $CIRFILE.out $CIRFILE.err");

# check various error cases
# These strings should be in the output of this failed Xyce run. 
# Note that ( ) and : characters must be escaped with \\
@searchstrings = ("Netlist error\\: Netlist analysis statement and measure mode \\(TRAN\\) for measure",
   "TRANMAX do not agree",
   "Netlist error: Netlist analysis statement and measure mode \\(TRAN_CONT\\) for",
   "measure TRAN_CONT_WHEN do not agree"
);

# re-measure should not work, but should produced a clean exit
$CMD = "$XYCE -remeasure $REMEASPRN $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
print "$CMD\n";
$retval = system($CMD);
if ($retval = 0)
{
   print "Xyce ran, when it should have failed\n";
   print "Exit code = 2\n";
   exit 2;
}
else
{
  $retval = $Tools->checkError("$CIRFILE.out",@searchstrings);
}

print "Exit code = $retval\n"; exit $retval; 
