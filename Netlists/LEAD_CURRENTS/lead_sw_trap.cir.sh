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
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

#
# now based on the prn file, make a comparison file where all the 
# lead current differences are zero

open(INPUT,"$CIRFILE.prn");
open(OUTPUT,">$CIRFILE.prn.gs");
while ($line = <INPUT>)
{
  # Handle first and last lines:
  if ($line =~ m/^[IE]/) 
  { 
    print OUTPUT "$line"; 
    next; 
  }
  @s = split(" ",$line);
  $a = 0;
  printf OUTPUT "%3d   %14.8e   %14.8e   %14.8e   %14.8e   %14.8e   \n",$s[0],$s[1],$s[2],$s[3],$a,$a;
}
close(INPUT);
close(OUTPUT);

#
# call xyce-verify to compare result to generated gold standard.
#
my $CMD="$XYCE_VERIFY $CIRFILE $CIRFILE.prn.gs $CIRFILE.prn > $CIRFILE.prn.out 2>$CIRFILE.prn.err";
$retval = system("$CMD");
# lower byte is not relevent here.  xyce_verify's return code is in
# the upper byte to shift it 8 bits.
$retval = $retval >> 8;
if( $retval == 20 )
{
  # xyce_verify return codes are different than what run_xyce_regression expects 
  # A return of 20 from xyce_verify is failed compare. So return that as "2" to 
  # run_xyce_regression so it can print a meaningful error. 
  $retval = 2
}
if ($retval != 0) 
{ 
  print "Exit code = $retval\n"; 
  exit $retval; 
}
print "Exit code = 0\n"; 
exit 0;


