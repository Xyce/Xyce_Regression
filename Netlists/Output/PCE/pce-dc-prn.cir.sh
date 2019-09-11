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
if ( !(-f "$CIRFILE.prn"))
{
    print STDERR "Missing output file $CIRFILE.prn\n";
    print "Exit code = 14\n"; exit 14;
}

if ( !(-f "$CIRFILE.PCE.prn"))
{
    print STDERR "Missing output file $CIRFILE.PCE.prn\n";
    print "Exit code = 14\n"; exit 14;
}

if ( !(-f "$CIRFILE.PCE.csv"))
{
    print STDERR "Missing output file $CIRFILE.PCE.csv\n";
    print "Exit code = 14\n"; exit 14;
}

if ( !(-f "$CIRFILE.PCE.noindex.prn"))
{
    print STDERR "Missing output file $CIRFILE.PCE.noindex.prn\n";
    print "Exit code = 14\n"; exit 14;
}

$retcode = 0;
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-6;
$fc = $XYCE_VERIFY;
$fc=~ s/xyce_verify/file_compare/;

$CMD="$fc $CIRFILE.PCE.prn $GOLDPRN.PCE.prn $absTol $relTol $zeroTol > $CIRFILE.PCE.prn.out 2> $CIRFILE.PCE.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.PCE.prn\n";
  $retcode = 2;
}

$CMD="$fc $CIRFILE.PCE.csv $GOLDPRN.PCE.csv $absTol $relTol $zeroTol > $CIRFILE.PCE.csv.out 2> $CIRFILE.PCE.csv.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.PCE.csv\n";
  $retcode = 2;
}

$CMD="$fc $CIRFILE.PCE.noindex.prn $GOLDPRN.PCE.noindex.prn $absTol $relTol $zeroTol > $CIRFILE.PCE.noindex.prn.out 2> $CIRFILE.PCE.noindex.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited with exit code $retval on file $CIRFILE.PCE.noindex.prn\n";
  $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;


