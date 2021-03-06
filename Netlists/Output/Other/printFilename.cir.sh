#!/usr/bin/env perl

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

use File::Basename;

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$GOLDPRN =~ s/\.prn$//; # remove the .prn at the end.
$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

# comparison tolerances for ACComparator.pl
$abstol=1e-6;
$reltol=1e-2;  #1%
$zerotol=1e-9;
$freqreltol=1e-6;

# remove previous output files and error files
system("rm -f $CIRFILE.HB.TD.* $CIRFILE.HB.FD.* $CIRFILE.hb_ic.* $CIRFILE.out $CIRFILE.err hbfile.FD.* hbfile");

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

# the .PRINT HB line uses file=hbfile
if ( !(-f "hbfile.HB.FD.prn")) {
    print STDERR "Missing output file hbfile\n";
    $xyceexit=14;
}
if ( !(-f "$CIRFILE.HB.TD.prn")) {
    print STDERR "Missing output file $CIRFILE.HB.TD.prn\n";
    $xyceexit=14;
}
if ( !(-f "hbfileic.cir.hb_ic.prn")) {
    print STDERR "Missing output file hbfileic.cir.hb_ic.prn\n";
    $xyceexit=14;
}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

$retcode = 0;

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl

if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $CIRFILE $GOLDRAW $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
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

$CMD="$XYCE_VERIFY $CIRFILE $GOLDPRN.HB.TD.prn $CIRFILE.HB.TD.prn > $CIRFILE.HB.TD.prn.out 2> $CIRFILE.HB.TD.prn.err";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.HB.TD.prn, see $CIRFILE.HB.TD.prn.err\n";
    $retcode = 2;
}

$golddirname = dirname($GOLDPRN);
$gold_hbfile = "$golddirname/hbfile";
$CMD="$XYCE_ACVERIFY $gold_hbfile hbfile.HB.FD.prn $abstol $reltol $zerotol $freqreltol > hbfile.HB.FD.prn.out 2> hbfile.HB.FD.prn.err";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file hbfile.HB.FD.prn, see hbfile.HB.FD.prn.err\n";
    $retcode = 2;
}

$gold_hbfileic = "$golddirname/hbfileic.cir.hb_ic.prn";
$CMD="$XYCE_VERIFY $CIRFILE $gold_hbfileic hbfileic.cir.hb_ic.prn > hbfileic.cir.hb_ic.prn.out 2> hbfileic.hb_ic.prn.err";
if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $CIRFILE.hb_ic.prn, see hbfileic.hb_ic.prn.err\n";
    $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;
