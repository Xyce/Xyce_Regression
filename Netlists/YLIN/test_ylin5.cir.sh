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
#$XYCE_ACVERIFY = $XYCE_VERIFY;
#$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

# comparison tolerances for ACComparator.pl
#$abstol=1e-6;
#$reltol=1e-4;  #0.01%
#$zerotol=1e-9;
#$freqreltol=1e-6;

# remove previous output files
system("rm -f $CIRFILE.out $CIRFILE.err $CIRFILE.HB.*");

# these files should not have been made, but remove them if they were
#system ("rm -f $CIRFILE.startup.prn $CIRFILE.hb_ic.prn");

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

# these files should not be made
#if ( -f "$CIRFILE.startup.prn" ) {
#    print STDERR "Output file $CIRFILE.startup.prn made, when it should not\n";
#    $xyceexit=2;
#}
#if ( -f "$CIRFILE.hb_ic.prn" ) {
#    print STDERR "Output file $CIRFILE.hb_ic.prn made, when it should not\n";
#    $xyceexit=2;
#}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

#verify output files
$retcode = 0;
$CMD="$XYCE_VERIFY $CIRFILE $GOLDPRN.HB.TD.prn $CIRFILE.HB.TD.prn > $CIRFILE.HB.TD.prn.out 2> $CIRFILE.HB.TD.prn.err";
if (system($CMD) != 0) {
    print STDERR "Verification failed on file $CIRFILE.HB.TD.prn, see $CIRFILE.HB.TD.prn.err\n";
    $retcode = 2;
}


print "Exit code = $retcode\n"; exit $retcode;
