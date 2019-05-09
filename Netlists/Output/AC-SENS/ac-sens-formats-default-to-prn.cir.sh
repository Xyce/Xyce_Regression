#!/usr/bin/env perl

use XyceRegression::Tools;
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

# If Xyce does not produce the appropriate output files, then we return exit code 14.
# If Xyce succeeds, but the test fails, then we return exit code 2.
# If the shell script fails for some reason, then we return exit code 1.

# Since the shell script runs Xyce and the comparison program, it is
# responsible for capturing any error output from Xyce and the STDOUT & STDERR
# from the comparison program.  The outside script, run_xyce_regression,
# expects the STDERR output from Xyce to go into $CIRFILE.err, the STDOUT
# output from comparison to go into $CIRFILE.prn.out and the STDERR output from
# comparison to go into $CIRFILE.prn.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$GOLDPRN =~ s/\.prn$//; # remove the .prn at the end.

system("rm -f $CIRFILE.FD.* $CIRFILE.out $CIRFILE.err");
system("rm -f $CIRFILE.raw* $CIRFILE.probe* $CIRFILE.ts*");

print "$CMD\n";
$CMD="$XYCE $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
$retval = system("$CMD");
if ($retval != 0)
{
  if ($retval & 127)
  {
    print "Exit code = 13\n";
    printf STDERR "Xyce crashed with signal %d on file %s\n",($retval&127),$CIRFILE;
    exit 13;
  }
  else
  {
    print "Exit code = 10\n";
    printf STDERR "Xyce exited with exit code %d on %s\n",$retval>>8,$CIRFILE;
    exit 10;
  }
}

$xyce_exit = 0;
if ( not -s "$CIRFILE.FD.prn")
{
  print "Missing output file $CIRFILE.FD.prn\n";
  print "Exit code =14\n";
  $xyce_exit = 14;
}

if ( (not -s "$CIRFILE.raw") || (not -s "$CIRFILE.probe") ||
     (not -s "$CIRFILE.ts1") || (not -s "$CIRFILE.ts2") )
{
  print "Missing output file $CIRFILE.raw, $CIRFILE.probe, CIRFILE.ts1 or $CIRFILE.ts2\n";
  print "Exit code =14\n";
  $xyce_exit = 14;
}

if ($xyce_exit != 0) { exit $xyce_exit;}

# these strings should be in the output of this successful Xyce run
@searchstrings = ("Netlist warning: Sensitivity output cannot be written in PROBE, RAW, Dakota or",
          "Touchstone format, using standard format instead",
          "Netlist warning: Sensitivity output cannot be written in PROBE, RAW, Dakota or",
          "Touchstone format, using standard format instead",
          "Netlist warning: Sensitivity output cannot be written in PROBE, RAW, Dakota or",
          "Touchstone format, using standard format instead",
          "Netlist warning: Sensitivity output cannot be written in PROBE, RAW, Dakota or",
          "Touchstone format, using standard format instead"
);

$retcode=0;

$retval = $Tools->checkError("$CIRFILE.out",@searchstrings);
if ($retval != 0)
{
  print "Check on warning message failed\n";
  $retcode = 2;
}

# now compare the test and gold file .prn files for .PRINT SENS
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-10;
$freqreltol=1e-6;
$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

$CMD="$XYCE_ACVERIFY $CIRFILE.raw $GOLDPRN.FD.SENS.prn $absTol $relTol $zeroTol $freqreltol > $CIRFILE.raw.out 2> $CIRFILE.raw.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0)
{
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.raw\n";
  $retcode = 2;
}

# The other three output files should be identical to $CIRFILE.raw
$CMD="diff $CIRFILE.raw $CIRFILE.probe > $CIRFILE.probe.out";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.probe, see $CIRFILE.probe.out\n";
    $retcode = 2;
}

$CMD="diff $CIRFILE.raw $CIRFILE.ts1 > $CIRFILE.ts1.out";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.ts1, see $CIRFILE.ts1.out\n";
    $retcode = 2;
}

$CMD="diff $CIRFILE.raw $CIRFILE.ts2 > $CIRFILE.ts2.out";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.ts2, see $CIRFILE.ts2.out\n";
    $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;



