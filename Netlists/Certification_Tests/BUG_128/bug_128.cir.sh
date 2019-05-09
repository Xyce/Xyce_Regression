#!/usr/bin/env perl

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
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

$CMD="$XYCE $CIRFILE > /dev/null 2> $CIRFILE.err";
if (system("$CMD") != 0) { print "Exit code = 10\n"; exit 10; }

open(OUT,"$CIRFILE.prn");
$line = <OUT>;
$line = <OUT>;
close(OUT);
@linelist = split(" ",$line);
$V1 = $linelist[2];
if ($V1 == 1.0)
{
  #print "Test Passed!\n";
  print "Exit code = 0\n"; exit 0;
}
else
{
  #print "Test Failed!\n";
  print "Exit code = 2\n"; exit 2;
}

