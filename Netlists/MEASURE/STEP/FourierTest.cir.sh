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

use Scalar::Util qw(looks_like_number);

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

# these are the tolerances used in comparing the measures calculated by this 
# script to those calculated by Xyce.  Zerotol is needed because some measured
# values should be zero (and reltol won't make sense in that case).

# phase is output in degrees and for fourier components with very small magnitude, 
# it can be have several degrees of scatter.  Thus it gets its own abstol
my $phaseAbsTol = 1.0;
my $relTol = 0.01;
my $zeroTol = 1.0e-8;
my $expectedDoubleCount=51;
my $defaultPrecision=6;
my $numSteps=2;

# change ending on gold standard file from ".prn" as passed in to ".mt0" 
# which is the file storing the measure results.

$GOLDPRN =~ s/.prn$//;

$CIRFILEBASE = $CIRFILE;
$CIRFILEBASE =~ s/.cir$//;
$CIRFILES0 = "$CIRFILEBASE.s0.cir";
$CIRFILES1 = "$CIRFILEBASE.s1.cir";

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILES0);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILES0.prn" ) { print "Exit code = 14\n"; exit 14; }

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILES1);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILES1.prn" ) { print "Exit code = 14\n"; exit 14; }

#
# Did we make a measure file
#
if (not -s "$CIRFILE.mt0" ) { print "Exit code = 17\n"; exit 17; }
if (not -s "$CIRFILE.mt1" ) { print "Exit code = 17\n"; exit 17; }
if (not -s "$CIRFILES0.mt0" ) { print "Exit code = 17\n"; exit 17; }
if (not -s "$CIRFILES1.mt0" ) { print "Exit code = 17\n"; exit 17; }

#
# Now we need to count the number of .MEASURE statements in the netlist
# and make sure we have some output for each one in the output file
#
open(NETLIST, "$CIRFILE");
$numMeasures=0;
my @measureNames = ("", "");
while( $line=<NETLIST> )
{
  if( $line =~ /^\.measure/i)
  {  
    $numMeasures++;
    # try to parse out ON= and OFF= values 
    @words = split( /\s+/, $line);
    @measureNames[ $numMeasures-1 ] = $words[2];
  }
}
close(NETLIST);

#
# Make sure the measurement was not output multiple times in parallel
# in either the output file or the measure file.
$numMeasOut = `grep -ic $measureNames[ $i ] $CIRFILE.out`;
if ( $numMeasOut != $numSteps )
{
   print "Xyce printed $measureNames[ $i ] measure to standard output incorrect number of times.\n";
   print "Number of Steps and Number of Measure Output = $numSteps, $numMeasOut\n";
   $retval = 2;
}

$numMeasMT0 = `grep -ic $measureNames[ $i ] $CIRFILE.mt0`;
$numMeasMT1 = `grep -ic $measureNames[ $i ] $CIRFILE.mt1`;
if ( ($numMeasMT0 != 1) || ($numMeasMT1 != 1) || ($numMeasMT0 != 1) )
{
  print "Xyce printed out $measureNames[ $i ] measure to file multiple times.\n";
  $retval = 2;
}

if ($retval !=0){print "Exit code = $retval\n";  exit $retval;}

# now compare the gold standards and the measure file contents
$retval = MeasureCommon::compareFourierMeasureFiles("$CIRFILES0.mt0", "$CIRFILE.mt0", $phaseAbsTol, $relTol, $zeroTol, $defaultPrecision,$expectedDoubleCount);
if ( $retval != 0 )
{
  print "Exit code = $retval\n"; 
  exit $retval;
}

$retval = MeasureCommon::compareFourierMeasureFiles("$CIRFILES1.mt0", "$CIRFILE.mt1", $phaseAbsTol, $relTol, $zeroTol, $defaultPrecision,$expectedDoubleCount);
if ( $retval != 0 )
{
  print "Exit code = $retval\n"; 
  exit $retval;
}
  
# now do re-measure
use File::Copy;
move("$CIRFILE.mt0","$CIRFILE.temp.mt0");
move("$CIRFILE.mt1","$CIRFILE.temp.mt1");

# here is the command to run xyce with remeasure
my $CMD="$XYCE -remeasure $CIRFILE.prn $CIRFILE > $CIRFILE.remeasure.out";
$retval=system($CMD)>>8;
  
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

# Did we make a measure file
if (not -s "$CIRFILE.mt0" ) { print "Exit code = 17\n"; exit 17; }

# rename the files
move("$CIRFILE.mt0","$CIRFILE.remeasure.mt0");
move("$CIRFILE.temp.mt0","$CIRFILE.mt0");
move("$CIRFILE.mt1","$CIRFILE.remeasure.mt1");
move("$CIRFILE.temp.mt1","$CIRFILE.mt1");

# now compare the re-measured and original file contents
$retval = MeasureCommon::compareFourierMeasureFiles("$CIRFILE.remeasure.mt0", "$CIRFILE.mt0", $phaseAbsTol, $relTol, $zeroTol, $defaultPrecision,$expectedDoubleCount);
if ( $retval != 0 )
{
  print "test Failed for re-measure of Step 0!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}

$retval = MeasureCommon::compareFourierMeasureFiles("$CIRFILE.remeasure.mt1","$CIRFILE.mt1", $phaseAbsTol, $relTol, $zeroTol, $defaultPrecision,$expectedDoubleCount);
if ( $retval != 0 )
{
  print "test Failed for re-measure of Step 1!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}
  
print "Exit code = $retval\n"; 
exit $retval;


