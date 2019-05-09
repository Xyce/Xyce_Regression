#!/usr/bin/env perl

use MeasureCommon;

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

$fc=$XYCE_VERIFY;
$fc =~ s/xyce_verify/file_compare/;

# remove files from previous runs
system("rm -f $CIRFILE.ms0 $CIRFILE.out $CIRFILE.err* $CIRFILE.remeasure*");

#
# Steps common to all of the measure tests are in the Perl module
# MeasureCommon.pm.  This file assumes the analysis type was .DC
#
MeasureCommon::checkDCFilesExist($XYCE,$CIRFILE);

# The next three blocks of code are used to compare the .MEASURE output
# to stdout to the "gold" stdout in the $GSFILE (EquationEvalTestDCGSfile).

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
my $GSFILE="EquationEvalTestDCGSfile";
my $absTol=1e-5;
my $relTol=1e-3;
my $zeroTol=1e-10;

$CMD="$fc $CIRFILE.errmsg $GSFILE $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval=system($CMD);
$retval = $retval >> 8;

if ( $retval != 0 )
{
  print STDERR "test failed comparison of stdout vs. GSfile with exit code $retval\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of stdout info\n";
}

# The next two blocks of code are used to compare the measured .ms0 file
# with the "Gold" .ms0 file, which is in OutputData/MEASURE_DC/
# Check that the Gold .ms0 file exists
$GOLDMS0 = $GOLDPRN;
$GOLDMS0 =~ s/prn$/ms0/;
#print "GOLDMS0 file = $GOLDMS0\n";
if (not -s "$GOLDMS0" ) 
{ 
  print "GOLD .ms0 file does not exist\n";
  print "Exit code = 17\n"; 
  exit 17; 
}

# compare gold and measured .ms0 files
$MEASUREMS0 = "$CIRFILE.ms0";
$CMD="$fc $MEASUREMS0 $GOLDMS0 $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval=system($CMD);
$retval = $retval >> 8;

if ( $retval != 0 )
{
  print STDERR "test failed comparison of Gold and measured .ms0 files with exit code $retval\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of .ms0 files\n";
}

# Also test remeasure if the basic measure function works
$retval = MeasureCommon::checkRemeasure($XYCE,$XYCE_VERIFY,$CIRFILE,$absTol,$relTol,$zeroTol,'prn',1,'ms');

print "Exit code = $retval\n";
exit $retval;

