#!/usr/bin/env perl

use XyceRegression::Tools;
use MeasureCommon;

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
#$GOLDPRN=$ARGV[4];

#
# Steps common to all of the measure tests are in the Perl module
# MeasureCommon.pm.  This file assumes the analysis type was .tran
#
MeasureCommon::checkTranFilesExist($XYCE,$CIRFILE);

# Parse the .cir to get the number of measures. Then deference to get the
# underlying array. This makes the subsequent code more readable since the
# variable are arrays or scalars, and aren't mixed in with array references. 
my ($numMeasures,$measuredQuantsRef) =  MeasureCommon::getNumMeasuresInCirFile($CIRFILE);
my @measureQuants = @$measuredQuantsRef;

# Process .mto file to get the measure names and measured values 
# for each measure statement. Then deference to get the underlying arrays.
# This makes the subsequent code more readable since the variable are 
# arrays or scalars, and aren't mixed in with array references. 
my ($measureNamesRef,$measureValsRef) 
          = MeasureCommon::parseMeasureNamesValues($CIRFILE,$numMeasures);
my @measureNames = @$measureNamesRef;
my @measureVals = @$measureValsRef;

# parse out the data from the .prn file.
my ($headVarNamesRef,$dataFromXyceRef) = MeasureCommon::parseTranPrnFile($CIRFILE);
my @headerVarNames = @$headVarNamesRef;
my @dataFromXyce = @$dataFromXyceRef;
my $endTime = $dataFromXyce[$#dataFromXyce][0];

#
# The next two code blocks may differ for each test
#
# parse the keywords in the .measure statements in the .cir file, 
# now that we know when the simulation ended.  This section of code may 
# may be different for each test
my ($precValsPtr,$precGivenPtr) = MeasureCommon::parseKeyWord($CIRFILE,"PRECISION",$endTime);
my @precVals = @$precValsPtr;
my @precGiven = @$precGivenPtr;
my $defaultPrecision=6;
print "A zero value in the line above means no PRECISION was on the instance line\n";
print "Will test those lines against a default value of $defaultPrecision\n\n";

#
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

  # case where a PRECISION value was specified on the MEASURE's instance line
  if ($precGiven[$j] == 1) 
  {
    if ($digitCount != $precVals[$j]) 
    {
      $retval =2; 
      print "Failed precision test for measure $measureNames[$j]\n";
      print "Specified and measured precision = ($precVals[$j],$digitCount)\n";
      print "Exit code = $retval\n";
      exit $retval;
    }
    else
    {
      print "Passed precision test for measure $measureNames[$j]\n";
      print "Specified and measured precision = ($precVals[$j],$digitCount)\n";
    }
  }
  else
  {
    if ($digitCount != $defaultPrecision) 
    {
      # using default value, which was set above in the $defaultPrecision variable.
      $retval =2;
      print "Failed default precision test for measure $measureNames[$j]\n";
      print "Default and measured precision = ($defaultPrecision,$digitCount)\n";
      print "Exit code = $retval\n";
      exit $retval;
    }
    else
    {
      print "Passed precision test for measure $measureNames[$j]\n";
      print "Default and measured precision = ($defaultPrecision,$digitCount)\n";
    }
  }  
}

print "Exit code = $retval\n";
exit $retval;

