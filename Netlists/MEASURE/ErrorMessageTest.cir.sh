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

# If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh", instead of the rest of this .sh file, and then exit
if ($XYCE_VERIFY =~ m/valgrind_check/)
{
  print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
  # do a measure run
  if (system("$XYCE_VERIFY $CIRFILE junk $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
  {
    print "Only did measure run\n";
    print "Exit code = 2 \n";
    exit 2;
  }
  else
  {
    # re-name the files from the measure run, so that the
    # data from the re-measure run does not overwrite them
    print "Measure passed valgrind testing\n";
    move("$CIRFILE.mt0","$CIRFILE.measure.mt0");
    move("$CIRFILE.out","$CIRFILE.measure.out");
    move("$CIRFILE.err","$CIRFILE.measure.err");
  }

  #now do a re-measure run
  print "Testing re-measure\n";
  my $CMD="$XYCE -remeasure $CIRFILE.prn $CIRFILE > $CIRFILE.out 2> $CIRFILE.err";
  my $retval=system($CMD)>>8;
  
  if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
  if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }
  
  if (system("$XYCE_VERIFY $CIRFILE junk $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
  {
    print "Exit code = 2 \n";
    exit 2;
  }
  else
  {
    print "Re-measure passed valgrind testing\n";
    print "Exit code = 0 \n";
    exit 0;
  }
}

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

# parse the precision keywords in the .measure statements in the .cir file, 
my ($precValsPtr,$precGivenPtr) = MeasureCommon::parseKeyWord($CIRFILE,"PRECISION",$endTime);
my @precVals = @$precValsPtr;
my @precGiven = @$precGivenPtr;
my $defaultPrecision=6;

# check that the values in the .mt0 file are formatted in 
# scientific notation with the correct precision.
foreach $j (0 .. $numMeasures-1)
{
  if ($measureNames[$j] eq "FOURFAIL" || $measureNames[$j] eq "FOUR1PTFAILT")
  {
    #print "Skipping checking number format for measure $measureNames[$j] in mt0 file\n";
  } 
  else
  {      
    # print "Checking number format for measure $measureNames[$j] in mt0 file\n";
    # precision is known.  So, second parameter is 1 in the function calls to
    # checkNumberFormat
    if ($precGiven[$j] > 0)
    {
      $retval = MeasureCommon::checkNumberFormat($measureVals[$j],1,$precVals[$j]);
    }
    else
    {
      $retval = MeasureCommon::checkNumberFormat($measureVals[$j],1,$defaultPrecision);
    }
  }
  if ( $retval != 0 )
  {
    print "test Failed precision test for measure $measureNames[$j] !\n";
    print "Exit code = $retval\n";
    exit $retval;
  }					       
}

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

# parse the .out file to find the text related to .MEASURE
my $foundStart=0;
my $foundEnd=0;
my @outLine;
my $lineCount=0;
while( $line=<NETLIST> )
{
  if ($line =~ /Measure Functions/) { $foundStart = 1; }
  if ($foundStart > 0 && $line =~ /Total Simulation/) { $foundEnd = 1; }  

  if ($foundStart > 0 && $foundEnd < 1)
  {
    print ERRMSG $line;
  } 
}

close(NETLIST);
close(ERRMSG);

# test that the values and strings in the .out file match to the required
# tolerances
my $GSFILE="ErrorMessageTestGSfile";
my $absTol=1e-5;
my $relTol=1e-3;
my $zeroTol=1e-10;

my $dirname = dirname($XYCE_VERIFY);
my $fc = "$dirname/file_compare.pl";
#print "$fc $CIRFILE.errmsg $GSFILE $absTol $relTol $zeroTol\n";
`$fc $CIRFILE.errmsg $GSFILE $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err`;
my $retval=$? >> 8;

if ( $retval != 0 )
{
  print "test Failed comparison vs. GSfile!\n";
  print "Exit code = $retval\n";
  exit $retval;
}

# check that the numbers in the .out file are formatted correctly in 
# scientific notation
if (-s "$CIRFILE.errmsg" )
{
  open(TESTFILE,"$testFileName");
  $lineCount=0;

  while( $lineTestFile=<TESTFILE> )
  {
    $lineCount++;
    # process a line into text and values.

    chop $lineTestFile;
    # Remove leading spaces on line, otherwise the spaces become 
    # element 0 of "testFileData" instead of the first column of data.
    $lineTestFile =~ s/^\s*//;
    @testFileData = (split(/[\s,]+/, $lineTestFile));
    for( $i=0; $i<=$#testFileData; $i++ )
    {
      if ( looks_like_number($testFileData[$i]) )
      {
        # precision is unknown. So, it won't be checked
        $retval = MeasureCommon::checkNumberFormat($testFileData[$i],0,$defaultPrecision);
        if ( $retval != 0 )
        {
          print "test Failed!\n";
          print "Exit code = $retval\n";
          exit $retval;
        }
      }
    }
  }
}

# do final checks on return value 
if ( $retval != 0 )
{
  print "test Failed!\n";
  print "Exit code = $retval\n";
  exit $retval;
}
else
{
  print "test passed!\n";
  print "Exit code = $retval\n";
  exit $retval;
}

