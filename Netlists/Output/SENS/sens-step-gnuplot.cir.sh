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

$GOLDPRN =~ s/\.prn$//; # remove the .prn at the end.

# remove old files if they exist
`rm -f $CIRFILE.SENS.prn $CIRFILE.out $CIRFILE.err`;
`rm -f $CIRFILE.SENS.prn.out $CIRFILE.SENS.prn.err`;

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

if ( not -s "$CIRFILE.SENS.prn") 
{
    print "Missing output file $CIRFILE.SENS.prn\n";
    print "Exit code =14\n";
    exit 14;
}

# now check the .SENS.prn file.
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-8;
$fc = $XYCE_VERIFY;
$fc=~ s/xyce_verify/file_compare/;
$CMD="$fc $CIRFILE.SENS.prn $GOLDPRN.SENS.prn $absTol $relTol $zeroTol > $CIRFILE.SENS.prn.out 2> $CIRFILE.SENS.prn.err";
$retval = system("$CMD");
if ($retval != 0)
{
  print "test Failed comparison of SENS.prn file vs. gold SENS.prn file!\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of SENS.prn files\n";
  print "Exit code = 0\n";
  exit 0;
}

