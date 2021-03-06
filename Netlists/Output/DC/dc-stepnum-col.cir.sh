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

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$GOLDNOINDEX =$GOLDPRN;
$GOLDNOINDEX =~ s/\.prn$/\.noindex\.prn/; # change ending to .splot.prn at the end.
$GOLDGNUPLOT =$GOLDPRN;
$GOLDGNUPLOT =~ s/\.prn$/\.gnuplot\.prn/; # change ending to .splot.prn at the end.
$GOLDSPLOT =$GOLDPRN;
$GOLDSPLOT =~ s/\.prn$/\.splot\.prn/; # change ending to .splot.prn at the end.

# remove old files if they exist
`rm -f $CIRFILE.prn $CIRFILE.noindex.* $CIRFILE.gnuplot.* $CIRFILE.splot.* $CIRFILE.out $CIRFILE.err`;
`rm -f $CIRFILE.prn.out $CIRFILE.prn.err`;

# run Xyce
$CMD="$XYCE $CIRFILE > $CIRFILE.out 2> $CIRFILE.err";
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
if ( not -s "$CIRFILE.prn")
{
    print STDERR "Missing output file $CIRFILE.prn\n";
    $xyce_exit = 14;
}

if ( !(-f "$CIRFILE.noindex.prn"))
{
  print STDERR "Missing output file $CIRFILE.noindex.prn\n";
  $xyce_exit = 14;
}

if ( !(-f "$CIRFILE.gnuplot.prn"))
{
  print STDERR "Missing output file $CIRFILE.gnuplot.prn\n";
  $xyce_exit = 14;
}

if ( !(-f "$CIRFILE.splot.prn"))
{
  print STDERR "Missing output file $CIRFILE.splot.prn\n";
  $xyce_exit = 14;
}

if ($xyce_exit != 0) { print "Exit code = $xyce_exit\n"; exit $xyce_exit;}

# now check the output files.
$retcode=0;
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-8;
$fc = $XYCE_VERIFY;
$fc=~ s/xyce_verify/file_compare/;
$CMD="$fc $CIRFILE.prn $GOLDPRN $absTol $relTol $zeroTol > $CIRFILE.prn.out 2> $CIRFILE.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited on file $CIRFILE.prn with exit code $retval\n";
  $retcode = 2;
}

$CMD="$fc $CIRFILE.noindex.prn $GOLDNOINDEX $absTol $relTol $zeroTol > $CIRFILE.noindex.prn.out 2> $CIRFILE.noindex.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited on file $CIRFILE.noindex.prn with exit code $retval\n";
  $retcode = 2;
}

$CMD="$fc $CIRFILE.gnuplot.prn $GOLDGNUPLOT $absTol $relTol $zeroTol > $CIRFILE.gnuplot.prn.out 2> $CIRFILE.gnuplot.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited on file $CIRFILE.gnuplot.prn with exit code $retval\n";
  $retcode = 2;
}

$CMD="$fc $CIRFILE.splot.prn $GOLDSPLOT $absTol $relTol $zeroTol > $CIRFILE.splot.prn.out 2> $CIRFILE.splot.prn.err";
$retval = system("$CMD");
$retval = $retval >> 8;
if ($retval != 0){
  print STDERR "Comparator exited on file $CIRFILE.splot.prn with exit code $retval\n";
  $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;

