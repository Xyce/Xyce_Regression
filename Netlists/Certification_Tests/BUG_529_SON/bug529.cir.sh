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

# Since the shell script runs Xyce and the comparison program, it is
# responsible for capturing any error output from Xyce and the STDOUT & STDERR
# from the comparison program.  The outside script, run_xyce_regression,
# expects the STDERR output from Xyce to go into $CIRFILE.err, the STDOUT
# output from comparison to go into $CIRFILE.prn.out and the STDERR output from
# comparison to go into $CIRFILE.prn.err.  

use Getopt::Long;

&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

# these are the tolerances used in comparing the measures calculated by this 
# script to those calculated by Xyce.  Zerotol is needed because some measured
# values should be zero (and reltol won't make sense in that case).

my $absTol = 3.0e-3;
my $relTol = 0.02;
my $zeroTol = 1.0e-5;

if (defined($verbose)) { $Tools->setVerbose(1); }

sub verbosePrint { $Tools->verbosePrint(@_); }

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

#
# Did we make any measure files.  We should not make any .mtX files 
# to pass this test.
#

#
# loop over all the steps
#
$numSteps = 7;

# if any step fails then retVal will be non-zero and indicate a failure 
$retval = 0;

for (my $stepNum=0; $stepNum < $numSteps; $stepNum++)
{
  #
  # Did we make a measure file
  #
  $measureFileName=$CIRFILE . ".mt" . $stepNum;
  if (-e $measureFileName ) 
  { 
    print "Found a measure file when Xyce should not have made one ", $measureFileName, "\n"; 
    print "Exit code = 2\n"; 
    exit 2; 
  }
}


if ( $retval != 0 )
{
  verbosePrint "test Failed!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}

verbosePrint "test Passed!\n";
print "Exit code = $retval\n"; 
exit $retval;
