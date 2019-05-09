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
$XYCE_VERIFY=~ s/xyce_verify/file_compare/;
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

#
# Steps common to all of the measure tests are in the Perl module
# MeasureCommon.pm.  This file assumes the analysis type was .ac
#
MeasureCommon::checkACFilesExist($XYCE,$CIRFILE);

# The next three blocks of code are used to compare the .MEASURE output
# to stdout to the "gold" stdout in the $GSFILE (ErrorTestACGSfile).

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
my $GSFILE="ErrorTestACGSfile";
my $absTol=1e-5;
my $relTol=1e-3;
my $zeroTol=1e-10;

$CMD="$XYCE_VERIFY $CIRFILE.errmsg $GSFILE $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval = system("$CMD");

if ( $retval != 0 )
{
  print "test Failed comparison of stdout vs. GSfile!\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of stdout info\n";
}

# The next two blocks of code are used to compare the measured .ma0 file
# with the "Gold" .ma0 file, which is in OutputData/MEASURE/ErrorTest.cir.ma0
# Check that the Gold .ma0 file exists
$GOLDMA0 = $GOLDPRN;
$GOLDMA0 =~ s/prn$/ma0/;
#print "GOLDMA0 file = $GOLDMA0\n";
if (not -s "$GOLDMA0" ) 
{ 
  print "GOLD .ma0 file does not exist\n";
  print "Exit code = 17\n"; 
  exit 17; 
}

# compare gold and measured .ma0 files
$MEASUREMA0 = "$CIRFILE.ma0";
#print "$fc $MEASUREMA0 $GOLDMA0 $absTol $relTol $zeroTol\n";
$CMD="$XYCE_VERIFY $MEASUREMA0 $GOLDMA0 $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval=system("$CMD");

if ( $retval != 0 )
{
  print "test Failed comparison of Gold and measured .ma0 files!\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of .ma0 files\n";
}

# Also test remeasure if the basic measure function works
if ($retval != 0)
{ 
  print "Exit code = $retval\n";
  exit $retval;
}
else
{ 
  # Re-measure test uses the same approach as the FOUR measure.
  # output files for .AC use .FD.prn extension, rather than .prn
  $retval = MeasureCommon::checkRemeasure($XYCE,$XYCE_VERIFY,$CIRFILE,$absTol,$relTol,$zeroTol,'FD.prn',1,'ma');
}

print "Exit code = $retval\n";
exit $retval;

