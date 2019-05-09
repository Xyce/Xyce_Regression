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
use File::Basename;
use File::Copy;

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

# Parse the .cir to get the number of measures. This then checks that each measure
# name appears the correct number of times in the output.  It may be a redundant check.
my ($numMeasures,$measuredQuantsRef) =  MeasureCommon::getNumMeasuresInCirFile($CIRFILE);

# The next three blocks of code are used to compare the .MEASURE output
# to stdout to the "gold" stdout in the $GSFILE (ErrorTestGSfile).  This 
# output contains the information for both steps.

# check that .out file exists, and open it if it does
if (not -s "$CIRFILE.out" ) 
{ 
  print "Exit code = 17\n"; 
  exit 17; 
}
else
{
  open(NETLIST, "$CIRFILE.out");
  open(ERRMSG,">$CIRFILE.errmsg") or die $!;
}

# Parse the .out file to find the text related to .MEASURE for all steps.
# The measure output in the stdout text for the first step is bracketed by 
# lines that contain "Measure Functions" and "Beginning DC Operating Point 
# Calculation".  The measure output in the stdout text for the second step 
# is bracketed by lines that contain "Measure Functions" and "Solution Summary".
# The code has not been tested for more than two steps, and may not work in that
# case.  
my $foundStart=0;
my $foundEnd=0;
my @outLine;
my $lineCount=0;
while( $line=<NETLIST> )
{
  if ($line =~ /Measure Functions/) 
  { 
    $foundStart = 1;
    $foundEnd = 0; 
  }
  
  if ($foundStart > 0 && $line =~ /LASTMEASURE/ )
  {
    print ERRMSG $line;
    #print "Found last measure line\n";
    $foundEnd = 1; 
    $foundStart = 0;
  }
  elsif ( ($foundStart > 0 && $line =~ /Solution Summary/) ||
       ($foundStart > 0 && $line =~ /Beginning DC Operating Point Calculation/) )
  { 
    $foundEnd = 1;
  }  

  if ($foundStart > 0 && $foundEnd < 1)
  {
    print ERRMSG $line;
  } 
}

close(NETLIST);
close(ERRMSG);

# test that the values and strings in the files $CIRFILE.errmsg and $GSFILE, for all steps, 
# match to the required tolerances
$GSFILE="ErrorTestGSfile";
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-10;

my $dirname = dirname($XYCE_VERIFY);
my $fc = "$dirname/file_compare.pl";
#print "$fc $CIRFILE.errmsg $GSFILE $absTol $relTol $zeroTol\n";
`$fc $CIRFILE.errmsg $GSFILE $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err`;
my $retval=$? >> 8;

if ( $retval != 0 )
{
  print "test Failed comparison of stdout vs. GSfile!\n";
  print "Exit code = $retval\n";
  exit $retval;
}
else
{
  print "Passed comparison of stdout info\n";
}

###################################################
# process each step.  Number of steps is hard-coded
###################################################
$numSteps=2;
foreach $stepNum (1 .. $numSteps)
{
  print "Processing data for step $stepNum\n";
  # Process .mt file to get the measure names and measured values 
  # for each measure statement. Then deference to get the underlying arrays.
  # This makes the subsequent code more readable since the variable are 
  # arrays or scalars, and aren't mixed in with array references. 
  my ($measureNamesRef,$measureValsRef) 
          = MeasureCommon::parseMeasureNamesValues($CIRFILE,$numMeasures,$stepNum-1,$numSteps);
  my @measureNames = @$measureNamesRef;
  my @measureVals = @$measureValsRef;

  # The next two blocks of code are used to compare the measured .mtX file
  # with the "Gold" .mtX file, which is in OutputData/MEASURE/ErrorTest.cir.mtX
  # Check that the Gold .mtX file exists
  $mtSuffix=$stepNum-1;
  $mtxString= "mt$mtSuffix";
  $GOLDMTX = $GOLDPRN;
  $GOLDMTX =~ s/prn$/$mtxString/;
  #print "GOLDMTX file = $GOLDMTX\n";
  $mtSuffix = $stepNum-1; 
  if (not -s "$GOLDMTX" ) 
  { 
    print "GOLD $mtxString file does not exist\n";
    print "Exit code = 17\n"; 
    exit 17; 
  }

  # compare gold and measured .mt files, for this step.
  $MEASUREMTX = "$CIRFILE.mt$mtSuffix";
  #print "$fc $MEASUREMTX $GOLDMTX $absTol $relTol $zeroTol\n";
  `$fc $MEASUREMTX $GOLDMTX $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err`;
  my $retval=$? >> 8;

  if ( $retval != 0 )
  {
    print "test Failed comparison of Gold and measured .mt$mtSuffix files!\n";
    print "Exit code = $retval\n";
    exit $retval;
  }
  else
  {
    print "Passed comparison of .mt$mtSuffix files\n";
  }
}

# Also test remeasure, if the basic measure function works
if ($retval != 0)
{ 
  print "Exit code = $retval\n";
  exit $retval;
}
else
{ 
  # Re-measure test uses the same approach as the FOUR measure
  $retval = MeasureCommon::checkRemeasure($XYCE,$XYCE_VERIFY,$CIRFILE,$absTol,$relTol,$zeroTol,"prn",$numSteps);
}

print "Exit code = $retval\n";
exit $retval;

