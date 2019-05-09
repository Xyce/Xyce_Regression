#!/usr/bin/env perl

use XyceRegression::Tools;
use MeasureCommon;

$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);
#$Tools->setVerbose(1);

if (defined($verbose)) { $Tools->setVerbose(1); }

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
#$GOLDPRN=$ARGV[4];

#
# Steps common to all of the measure tests are in the Perl module
# MeasureCommon.pm.  This file assumes the analysis type was .tran
#
MeasureCommon::checkTranFilesExist($XYCE,$CIRFILE);

# hard code this
my $numMeasures = 14;

# Process .mto file to get the measure names and measured values 
# for each measure statement. Then deference to get the underlying arrays.
# This makes the subsequent code more readable since the variable are 
# arrays or scalars, and aren't mixed in with array references. 
my ($measureNamesRef,$measureValsRef) 
          = MeasureCommon::parseMeasureNamesValues($CIRFILE,$numMeasures);
my @measureNames = @$measureNamesRef;
my @measureVals = @$measureValsRef;

# hard code this value rather than parsing it from the .cir file
my $defaultPrecision=4;

# check the precision in the .mt0 file only.  Printing to stdout
# uses the same code.  So, this should suffice unless we see a
# problem.
my $retval=0;
my $foundDot;
my $idx;
my $token;

foreach $j (0 .. $numMeasures-1)
{
  $foundDot=0;
  $digitCount=0;
  #print "measureVal for measure $j = $measureVals[$j]\n";
  foreach $idx (0 .. length($measureVals[$j]))
  {
    $token = substr($measureVals[$j],$idx,1);
    #print "token for index $idx = $token\n";
    if ( ($token =~/[.]/) )
    {
      $foundDot=1;
      #print("\tFound dot character\n");
    }
    elsif  ( ($token =~ /[0-9]/) && ($foundDot > 0) )
    {
      #print "\tIncrementing digit count for character $token\n";
      $digitCount++;
    }
    elsif ( ($token =~ /e/) && ($foundDot > 0) )
    {
      #print "\tFound an exponential character (e).  Ending loop ...\n";
      last;
    }  
  }

  if ($digitCount != $defaultPrecision) 
  {
    # using default value, which was set above in the $defaultPrecision variable.
    $retval =2;
    print "Failed default precision test for measure $measureNames[$j]\n";
    print "MEASDGT and measured precision = ($defaultPrecision,$digitCount)\n";
    print "Exit code = $retval\n";
    exit $retval;
  }
  else
  {
    print "Passed precision test for measure $measureNames[$j]\n";
    print "MEASDGT and measured precision = ($defaultPrecision,$digitCount)\n";
  }  
}

print "Exit code = $retval\n";
exit $retval;

