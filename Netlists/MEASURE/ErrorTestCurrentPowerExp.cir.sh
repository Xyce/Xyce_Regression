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

# The next three blocks of code are used to compare the .MEASURE output
# to stdout to the "gold" stdout in the $GSFILE (ErrorTestGSfile).

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
my $GSFILE="ErrorTestCurrentPowerExpGSfile";
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
  print "test Failed comparison of stdout vs. GSfile!\n";
  print "Exit code = $retval\n";
  exit $retval;
}
else
{
  print "Passed comparison of stdout info\n";
}

# The next two blocks of code are used to compare the measured .mt0 file
# with the "Gold" .mt0 file, which is in OutputData/MEASURE/ErrorTest.cir.mt0
# Check that the Gold .mt0 file exists
$GOLDMT0 = $GOLDPRN;
$GOLDMT0 =~ s/prn$/mt0/;
#print "GOLDMT0 file = $GOLDMT0\n";
if (not -s "$GOLDMT0" ) 
{ 
  print "GOLD .mt0 file does not exist\n";
  print "Exit code = 17\n"; 
  exit 17; 
}

# compare gold and measured .mt0 files
$MEASUREMT0 = "$CIRFILE.mt0";
#print "$fc $MEASUREMT0 $GOLDMT0 $absTol $relTol $zeroTol\n";
`$fc $MEASUREMT0 $GOLDMT0 $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err`;
my $retval=$? >> 8;

if ( $retval != 0 )
{
  print "test Failed comparison of Gold and measured .mt0 files!\n";
  print "Exit code = $retval\n";
  exit $retval;
}
else
{
  print "Passed comparison of .mt0 files\n";
}

# Skip this part of the test until re-measure of lead currents and expressions works.
# Also test remeasure if the basic measure function works
#if ($retval != 0)
#{ 
#  print "Exit code = $retval\n";
#  exit $retval;
#}
#else
#{ 
  # Re-measure test uses the same approach as the FOUR measure
#  $retval = MeasureCommon::checkRemeasure($XYCE,$XYCE_VERIFY,$CIRFILE,$absTol,$relTol,$zeroTol);
#}

print "Exit code = $retval\n";
exit $retval;

