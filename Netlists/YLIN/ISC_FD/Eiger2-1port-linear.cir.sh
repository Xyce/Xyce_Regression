#!/usr/bin/env perl

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
$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

@CIR;
$CIR[0]="Eiger2-1port-linear-ma.cir";

# comparison tolerances for ACComparator.pl
$abstol=1e-6;
$reltol=1e-1;  #0.1%
$zerotol=1e-9;
$freqreltol=1e-6;

# remove previous output files
system("rm -f $CIRFILE.out $CIRFILE.err $CIRFILE.HB.* $CIRFILE.hb_ic.* $CIRFILE.startup.*");

foreach $i (0 ..0)
{
  system("rm -f $CIR[$i].HB.TD.* $CIR[$i].HB.FD.* $CIR[$i].out $CIR[$i].err");
}

#run Xyce
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

# check for output files
if ( !(-f "$CIRFILE.HB.TD.prn")) {
    print STDERR "Missing output file $CIRFILE.HB.TD.prn\n";
    $xyceexit=14;
}
if ( !(-f "$CIRFILE.HB.FD.prn")) {
    print STDERR "Missing output file $CIRFILE.HB.FD.prn\n";
    $xyceexit=14;
}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl
if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $CIRFILE $GOLDCSV $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
    {
        print "Exit code = 2 \n";
        exit 2;
    }
    else
    {
        print "Exit code = 0 \n";
        exit 0;
    }
}

# verify output files
$retcode = 0;
$CMD="$XYCE_ACVERIFY $GOLDPRN.HB.FD.prn $CIRFILE.HB.FD.prn $abstol $reltol $zerotol $freqreltol > $CIRFILE.HB.FD.prn.out 2> $CIRFILE.HB.FD.prn.err";
if (system($CMD) != 0) {
    print STDERR "Verification failed on file $CIRFILE.HB.FD.prn, see $CIRFILE.HB.FD.prn.err\n";
    $retcode = 2;
}

if ($retcode == 0) {print "Passed base case (RI) comparison\n"; }

# now run the non-base cases, and diff the results against the base case
foreach $i (0 ..0)
{
  $CMD="$XYCE $CIR[$i] > $CIR[$i].out 2>$CIR[$i].err";
  $retval=system($CMD);

  if ($retval != 0)
  {
    if ($retval & 127)
    {
      print "Exit code = 13\n";
      printf STDERR "Xyce crashed with signal %d on file %s\n",($retval&127),$CIR[$i];
      exit 13;
    }
    else
    {
      print "Exit code = 10\n";
      printf STDERR "Xyce exited with exit code %d on %s\n",$retval>>8,$CIR[$i];
      exit 10;
    }
  }

  if ( !(-f "$CIR[$i].HB.TD.prn")) {
    print STDERR "Missing output file $CIR[$i].HB.TD.prn\n";
    $xyceexit=14;
  }
  if ( !(-f "$CIR[$i].HB.FD.prn")) {
    print STDERR "Missing output file $CIR[$i].HB.FD.prn\n";
    $xyceexit=14;
  }

  if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

  $CMD="diff $CIR[$i].HB.FD.prn $CIRFILE.HB.FD.prn > $CIR[$i].HB.FD.prn.out 2> $CIR[$i].HB.FD.prn.err";
  $retval = system($CMD);
  $retval = $retval >> 8;
  if ($retval != 0)
  {
    print STDERR "Diff failed on file $CIR[$i].HB.FD.prn with exit code $retval\n";
    $retcode = 2;
  }
}

if ($retcode == 0) {print "Passed other case (MA) comparison\n"; }


print "Exit code = $retcode\n"; exit $retcode;
