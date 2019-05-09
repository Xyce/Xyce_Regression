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

# remove files from previous runs
system("rm -f $CIRFILE.out $CIRFILE.err");

# check various error cases
# this string should be in the output of this failed Xyce run  
@searchstrings = ("First column of comparison file must be Index for DC-mode remeasure"
);

# re-measure should not work, but should produce a clean exit
$CMD = "$XYCE -remeasure $GOLDPRN $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
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
