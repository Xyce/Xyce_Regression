#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);
#$Tools->setVerbose(1);

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script 
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

# If Xyce does not produce a prn file, then we return exit code 10.
# If Xyce succeeds, but the test fails, then we return exit code 2.
# If the shell script fails for some reason, then we return exit code 1.
# Otherwise we return the exit code of compare or xyce_verify.pl

# Since the shell script runs Xyce also, it is responsible for capturing any
# error output from Xyce.  The script run_xyce_regression captures the test
# output and handles the resulting files.  

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
#$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$CIR1="capTop.cir";
$CIR2="capInner.cir";

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIR1);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }

$retval = -1;
print "$XYCE_VERIFY $CIR2 $GOLDPRN $CIR2.prn $CIR1.plotfile > $CIR2.prn.out 2> $CIR2.prn.err\n";
$retval = system("$XYCE_VERIFY $CIR2 $GOLDPRN $CIR2.prn $CIR1.plotfile > $CIR2.prn.out 2> $CIR2.prn.err");
if ($retval == 0) { print "Exit code = 0\n"; exit 0; } else { print "Exit code = 2\n"; exit 2; }


