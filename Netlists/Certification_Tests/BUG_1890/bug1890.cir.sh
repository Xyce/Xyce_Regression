#!/usr/bin/env perl

use XyceRegression::Tools;

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
if ($retval == 0) { print "Xyce ran when it should have failed!\nExit code = 2\n"; exit 2; }

# check the output file for the correct error 
open(XYCE_OUTPUT, "$CIRFILE.out");
my $foundCorrectErrorMsg=0;
while( $line=<XYCE_OUTPUT> )
{
  #if( $line =~ /Can\'t find context for expression variable IVS in expression/)
  if( $line =~ /Function IVS is not resolved/)
  { 
    $foundCorrectErrorMsg=1;
    break;
  }
}
close( XYCE_OUTPUT );

if( $foundCorrectErrorMsg == 1 )
{
  # return a passing return value
  $retval = 0;
  print "Xyce failed as expected.\n";
}
else
{
  print "Xyce failed with the wrong error for this bug.\n";
}


print "Exit code = $retval\n";
exit $retval;
