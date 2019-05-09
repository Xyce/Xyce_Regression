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
# output from comparison to go into $CIRFILE.csv.out and the STDERR output from
# comparison to go into $CIRFILE.csv.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDCSV=$ARGV[4];

$GOLDCSV =~ s/\.prn$//; # remove the .csv at the end.
$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

# comparison tolerances for ACComparator.pl
$abstol=1e-6;
$reltol=1e-3;  #0.1%
$zerotol=1e-10;
$freqreltol=1e-6;

#remove previous output files
system("rm -f $CIRFILE.HB.TD.* $CIRFILE.HB.FD.* $CIRFILE.hb_ic.* $CIRFILE.out $CIRFILE.err");

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
if ( !(-f "$CIRFILE.HB.TD.csv")) {
    print STDERR "Missing output file $CIRFILE.HB.TD.csv\n";
    $xyceexit=14;
}
if ( !(-f "$CIRFILE.HB.FD.csv")) {
    print STDERR "Missing output file $CIRFILE.HB.FD.csv\n";
    $xyceexit=14;
}
if ( !(-f "$CIRFILE.hb_ic.csv")) {
    print STDERR "Missing output file $CIRFILE.hb_ic.csv\n";
    $xyceexit=14;
}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

$retcode = 0;

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl
if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $CIRFILE $GOLDRAW $CIRFILE.csv > $CIRFILE.csv.out 2>&1 $CIRFILE.csv.err"))
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

$CMD="$XYCE_VERIFY $CIRFILE $GOLDCSV.HB.TD.csv $CIRFILE.HB.TD.csv > $CIRFILE.HB.TD.csv.out 2> $CIRFILE.HB.TD.csv.err";
if (system($CMD) != 0) {
    print STDERR "Verification failed on file $CIRFILE.HB.TD.csv, see $CIRFILE.HB.TD.csv.err\n";
    $retcode = 2;
}

$CMD="$XYCE_ACVERIFY --gsformat=xycecsv $GOLDCSV.HB.FD.csv $CIRFILE.HB.FD.csv $abstol $reltol $zerotol $freqreltol > $CIRFILE.HB.FD.csv.out 2> $CIRFILE.HB.FD.csv.err";
if (system($CMD) != 0) {
    print STDERR "Verification failed on file $CIRFILE.HB.FD.csv, see $CIRFILE.HB.FD.csv.err\n";
    $retcode = 2;
}

$CMD="$XYCE_VERIFY $CIRFILE $GOLDCSV.hb_ic.csv $CIRFILE.hb_ic.csv > $CIRFILE.hb_ic.csv.out 2> $CIRFILE.hb_ic.csv.err";
if (system($CMD) != 0) {
    print STDERR "Verification failed on file $CIRFILE.hb_ic.csv, see $CIRFILE.hb_ic.csv.err\n";
    $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;
