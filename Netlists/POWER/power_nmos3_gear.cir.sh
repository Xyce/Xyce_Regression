#!/usr/bin/env perl

use XyceRegression::Tools;
use PowerCommon;

$Tools = XyceRegression::Tools->new();

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

# Since the shell script runs Xyce and the comparison program, it is
# responsible for capturing any error output from Xyce and the STDOUT & STDERR
# from the comparison program.  The outside script, run_xyce_regression,
# expects the STDERR output from Xyce to go into $CIRFILE.err, the STDOUT
# output from comparison to go into $CIRFILE.prn.out and the STDERR output from
# comparison to go into $CIRFILE.prn.err.  

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }

# First test that can parse the W() or P() on the .print line
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

# get the data in the .PRN file, return as an array
@prnData = PowerCommon::parseTranPrnFile($CIRFILE);
if ($#prnData == 0)
{
  print "no data found in .prn file\n";
  print "Exit code = 2\n";
  exit 2;
}

# set the comparison tolerances and the columns to compare for this test
$absTol = 1e-7;
$relTol = 2e-5;
$zeroTol = 1e-15;
$pbZeroTol = 7e-10;

$pCalcColIdx = 4; # P(M1) calculated, via formula
$pXyceColIdx = 2; # P(M1) reported by Xyce 
$wXyceColIdx = 3; # W(M1) reported by Xyce

# Do the comparison based on the formula.  Pass in a reference to @prnData
$retval1 = PowerCommon::comparePowerColumns(\@prnData,$pCalcColIdx,$pXyceColIdx,$wXyceColIdx,$absTol,$relTol,$zeroTol);
if ($retval1 != 0)
{
  print "Failed power test for MOSFET, based on expected calculation result\n";
}

$pCalcColIdx = 5; # P(M1) calculated, from combined source dissipation
$pXyceColIdx = 2; # P(M1) reported by Xyce 
$wXyceColIdx = 3; # W(M1) reported by Xyce
# Do based on combined source dissipation.  Pass in a reference to @prnData
$retval2 = PowerCommon::comparePowerColumns(\@prnData,$pCalcColIdx,$pXyceColIdx,$wXyceColIdx,$absTol,$relTol,$pbZeroTol);
if ($retval2 != 0)
{
  print "Failed power test for MOSFET, based on power dissipation of sources\n";
}

if ($retval1 != 0) 
{ 
  print "Exit code = $retval1\n"; 
  exit $retval1; 
}
elsif ($retval2 != 0)
{ 
  print "Exit code = $retval2\n"; 
  exit $retval2; 
}

print "Exit code = 0\n"; 
exit 0;


