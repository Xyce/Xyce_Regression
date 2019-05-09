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
$GOLDPRN=$ARGV[4];

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
my @fromVals = MeasureCommon::parseKeyWord($CIRFILE,"FROM",$endTime);
my @toVals = MeasureCommon::parseKeyWord($CIRFILE,"TO",$endTime);
my @tdVals = MeasureCommon::parseKeyWord($CIRFILE,"TD",$endTime);
my @defaultVals = MeasureCommon::parseKeyWord($CIRFILE,"DEFAULT_VAL",$endTime); 

# for these keywords, whether they were given matters later in the .sh file
my ($riseValsPtr,$riseGivenPtr) =  MeasureCommon::parseKeyWord($CIRFILE,"RISE",$endTime);
my @riseVals = @$riseValsPtr;
my @riseGiven = @$riseGivenPtr;
my ($fallValsPtr,$fallGivenPtr) =  MeasureCommon::parseKeyWord($CIRFILE,"FALL",$endTime);
my @fallVals = @$fallValsPtr;
my @fallGiven = @$fallGivenPtr;
my ($crossValsPtr,$crossGivenPtr) =  MeasureCommon::parseKeyWord($CIRFILE,"CROSS",$endTime);  
my @crossVals = @$crossValsPtr;
my @crossGiven = @$crossGivenPtr;
my ($rfcLevelValsPtr,$rfcLevelGivenPtr) =  MeasureCommon::parseKeyWord($CIRFILE,"RFC_LEVEL",$endTime);  
my @rfcLevelVals = @$rfcLevelValsPtr;
my @rfcLevelGiven = @$rfcLevelGivenPtr;

#
# now calculate the values for this measures.  This is the part of 
# the test script may also different for each test. 
# 
# Find the peak-to-peak value for each voltage, but ignore data outside
# of the intersection of >=TD and FROM>= and <=TO
my @calcVals;
my @minVals;
my @maxVals;
my $firstValue;
my $colIdx;
my $validRFCwindow;
my $firstTimeStepInWindow;
my $isRising;
my $isFalling;
my $riseCount;
my $fallCount;
my $crossCount;
my $previousVal;

foreach $j (0 .. $numMeasures-1){
  $firstValue=0;
  $calcVals[$j] = $defaultVals[$j];

  if ($tdVals[$j] > $toVals[$j])
  {
    # no op, since this statement was moved above the if-else block
    #$calcVals[$j] = $defaultVals[$j];
  }
  else
  {
    # find the correct column in the output data, collected from the .prn file
    $colIdx = MeasureCommon::findColumnInPrnFile($measureQuants[$j],\@headerVarNames);

    # reset validRFCwindow and firstTimeStepInWindow flags
    $validRFCwindow=0;
    $firstTimeStepInWindow=0;
    $isRising=0;
    $isFalling=0;
    $riseCount=0;
    $fallCount=0;
    $crossCount=0;

    # process that column.  This code section will be specific to each measure
    for $i (0 .. $#dataFromXyce )
    {  
      if (($dataFromXyce[$i][0]>=$tdVals[$j]) && ($dataFromXyce[$i][0]>=$fromVals[$j]) && 
         ($dataFromXyce[$i][0]<=$toVals[$j]))
      {
        # set prevValue variable at first time step in window
        if ($firstTimeStepInWindow < 1)
        {
	  $firstTimeStepInWindow = 1;
          $previousVal = $dataFromXyce[$i][$colIdx];
        }

        # determine if we're within the RFC window    
        ($riseCount,$fallCount,$crossCount,$isRising,$isFalling,
           $validRFCwindow,$previousVal,$newRFCwindowForLast) = 
              MeasureCommon::withinRFCwindow($dataFromXyce[$i][$colIdx],$previousVal,
		  $isRising,$isFalling,$riseCount,$fallCount,$crossCount,
                  $riseGiven[$j],$fallGiven[$j],$crossGiven[$j],
                  $riseVals[$j],$fallVals[$j],$crossVals[$j],
                  $rfcLevelVals[$j],$rfcLevelGiven[$j]);
        
        #print ("For index $i, validRFCwindow = $validRFCwindow\n");
        if ($validRFCwindow > 0)
        {
          if ($newRFCwindowForLast > 0) 
          {
            $firstValue=0;
            #print "New RFC window at time $dataFromXyce[$i][0]\n";
            #print "RFC Counts=($riseCount,$fallCount,$crossCount)\n";
          }

          if ($firstValue==0)
          {
	    $firstValue=1;
            $minVals[$j] = $dataFromXyce[$i][$colIdx];
            $maxVals[$j] = $dataFromXyce[$i][$colIdx];
          }
          else
          {
            if ($dataFromXyce[$i][$colIdx] < $minVals[$j])
            {
	      $minVals[$j] = $dataFromXyce[$i][$colIdx];
	    }
            if ($dataFromXyce[$i][$colIdx] > $maxVals[$j])
            {
	      $maxVals[$j] = $dataFromXyce[$i][$colIdx];
	    }
          }
	}
      }
    }
    
    # only do this calculation if we met the RFC window criteria.
    # otherwise $calcVals[$j] was previously set to the default value
    if ($firstValue > 0) {$calcVals[$j] = $maxVals[$j] - $minVals[$j];}
  }
}

# these are the tolerances used in comparing the measures calculated by this 
# script to those calculated by Xyce.  Zerotol is needed because some measured
# values should be zero (and reltol won't make sense in that case).
my $absTol = 1.0e-4;
my $relTol = 0.02;
my $zeroTol = 1.0e-5;

#
# Print the test results based on relative and absolute error.  This is common to all
# tests.  This subroutine returns a value rather than exiting from the script. 
# 
my $retval = MeasureCommon::printResults($numMeasures,$absTol,$relTol,$zeroTol,\@measureNames,
                                   \@measureVals,\@calcVals);

# Also test remeasure if the basic measure function works
if ($retval != 0)
{ 
  print "Exit code = $retval\n";
  exit $retval;
}
else
{ 
  # Re-measure test uses the same approach as the FOUR measure
  $retval = MeasureCommon::checkRemeasure($XYCE,$XYCE_VERIFY,$CIRFILE,$absTol,$relTol,$zeroTol);
}

print "Exit code = $retval\n";
exit $retval;

