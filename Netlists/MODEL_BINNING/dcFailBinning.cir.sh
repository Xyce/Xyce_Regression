#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();

# The input arguments to this script are: 
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script 
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

use Getopt::Long;

# these search strings are supposed to occur one right after the other in the
# error output.  Note that parens are escaped with \\
@searchstrings = ("Model is required for device M1 and no valid model card found");

&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

if (defined($verbose)) { $Tools->setVerbose(1); }

$retval = $Tools->runAndCheckError($CIRFILE,$XYCE,@searchstrings);
print "Exit code = $retval\n";
exit $retval

