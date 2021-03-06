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
# output from comparison to go into $CIRFILE.dat.out and the STDERR output from
# comparison to go into $CIRFILE.dat.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$GOLDPRN =~ s/\.prn$//; # remove the .prn at the end.

# remove previous output files
system("rm -f $CIRFILE.PCE.* $CIRFILE.out $CIRFILE.err $CIRFILE.prn");

# run Xyce
$CMD="$XYCE $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
$retval=system($CMD);

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

# check for the output files
if ( !(-f "$CIRFILE.PCE.raw"))
{
    print STDERR "Missing output file $CIRFILE.PCE.raw\n";
    print "Exit code = 14\n"; exit 14;
}

if ( !(-f "$CIRFILE.PCE.probe"))
{
    print STDERR "Missing output file $CIRFILE.PCE.probe\n";
    print "Exit code = 14\n"; exit 14;
}

if ( !(-f "$CIRFILE.PCE.ts1"))
{
    print STDERR "Missing output file $CIRFILE.PCE.ts1\n";
    print "Exit code = 14\n"; exit 14;
}

if ( !(-f "$CIRFILE.PCE.ts2"))
{
    print STDERR "Missing output file $CIRFILE.PCE.ts2\n";
    print "Exit code = 14\n"; exit 14;
}

$retcode = 0;
# these strings should be in the output of this successful Xyce run
@searchstrings = ("Netlist warning: PCE output cannot be written in PROBE, RAW or Touchstone",
          "format, using standard format instead",
          "Netlist warning: PCE output cannot be written in PROBE, RAW or Touchstone",
          "format, using standard format instead",
          "Netlist warning: PCE output cannot be written in PROBE, RAW or Touchstone",
          "format, using standard format instead",
          "Netlist warning: PCE output cannot be written in PROBE, RAW or Touchstone",
          "format, using standard format instead"
);

$retval = $Tools->checkError("$CIRFILE.out",@searchstrings);
if ($retval != 0)
{
  print "Check on warning message failed\n";
  $retcode = 2;
}

# test the output files
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-6;
$fc = $XYCE_VERIFY;
$fc=~ s/xyce_verify/file_compare/;

$CMD="$fc $CIRFILE.PCE.raw $GOLDPRN.PCE.prn $absTol $relTol $zeroTol > $CIRFILE.PCE.raw.out 2> $CIRFILE.PCE.raw.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.PCE.raw\n";
  $retcode = 2;
}

# The other three output files should be identical to $CIRFILE.PCE.raw
$CMD="diff $CIRFILE.PCE.raw $CIRFILE.PCE.probe > $CIRFILE.PCE.probe.out";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.PCE.probe, see $CIRFILE.PCE.probe.out\n";
    $retcode = 2;
}

$CMD="diff $CIRFILE.PCE.raw $CIRFILE.PCE.ts1 > $CIRFILE.PCE.ts1.out";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.PCE.ts1, see $CIRFILE.PCE.ts1.out\n";
    $retcode = 2;
}

$CMD="diff $CIRFILE.PCE.raw $CIRFILE.PCE.ts2 > $CIRFILE.PCE.ts2.out";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.PCE.ts2, see $CIRFILE.PCE.ts2.out\n";
    $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;

