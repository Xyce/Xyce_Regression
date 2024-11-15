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
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
#$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

$helpretval=system("$XYCE -h > CmdParse_help.txt");
$emptyretval=system("$XYCE > CmdParse_empty.txt 2>/dev/null");

if ($helpretval != 0) {
    print "Test -h failed\n";
    $retval=1;
}
elsif ($emptyretval != 0) {
    print "Test empty wrongly succeeded\n";
    $retval=1;
}
else {
    $retval=system("grep -v 'User error' CmdParse_empty.txt | diff -B - CmdParse_help.txt");
    if ($retval == 0) {
        print "Usage message was the same when it should be different between -h and empty\n";
    } else {
      $retval = 0;
    }
}

print "Exit code = $retval\n";
exit $retval


