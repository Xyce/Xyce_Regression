#!/usr/bin/env perl

use MeasureCommon;
use XyceRegression::Tools;
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
$GOLDPRN=$ARGV[4];

$fc=$XYCE_VERIFY;
$fc =~ s/xyce_verify/file_compare/;

# remove files from previous runs
system("rm -f $CIRFILE.mt0 $CIRFILE.fft* $CIRFILE.out $CIRFILE.err* $CIRFILE.prn*");

#
# Steps common to all of the measure tests are in the Perl module
# MeasureCommon.pm.  This file assumes the analysis type was .TRAN
#
MeasureCommon::checkFFTFilesExist($XYCE,$CIRFILE);

# test tolerances
$absTol=1e-3;
$relTol=1e-3;
$zeroTol=1e-10;
$retcode = 0;

# The test will fail if this warning is not produced
@searchstrings=("Netlist warning: FFT_ACCURATE reset to 0, because .OPTIONS OUTPUT",
   "INITIAL_INTERVAL used");
$retval = $Tools->checkError("$CIRFILE.out", @searchstrings);
if ($retval !=0)
{
  print "Warning message about FFT_ACCURATE reset not found\n";
  $retcode = 2;
}

# The next two blocks of code are used to compare the measured .mt0 file
# with the "Gold" .mt0 file, which is in OutputData/MEASURE_FFT/
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
$CMD="$fc $MEASUREMT0 $GOLDMT0 $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval=system($CMD);
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.fft0\n";
  $retcode = 2;
}

# compare .fft0 output also
$GOLDFFT = $GOLDPRN;
$GOLDFFT =~ s/\.prn$//;

if ( !(-f "$CIRFILE.fft0"))
{
  print STDERR "Missing output file $CIRFILE.fft0\n";
  print "Exit code = 2\n";
  exit 2;
}

$CMD="$fc $CIRFILE.fft0 $GOLDFFT.fft0 $absTol $relTol $zeroTol > $CIRFILE.fft0.out 2> $CIRFILE.fft0.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.fft0\n";
  $retcode = 2;
}

# compare .prn output, to verify that the measured values are the "default value" until the
# last time step.
$CMD="$fc $CIRFILE.prn $GOLDPRN $absTol $relTol $zeroTol > $CIRFILE.prn.out 2> $CIRFILE.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.prn\n";
  $retcode = 2;
}

print "Exit code = $retcode\n";
exit $retcode;
