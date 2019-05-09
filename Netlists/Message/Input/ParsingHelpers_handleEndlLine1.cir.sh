#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);

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

use Getopt::Long;
&GetOptions( "verbose!" => \$verbose );
if (defined($verbose)) { $Tools->setVerbose(1); }
$Tools->setVerbose(1);

$XYCE=$ARGV[0];
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

# these search strings are supposed to occur in the error output
@searchstrings = (["Netlist error in file bogoLib1 at or near line 7",
   ".ENDL encountered without library name, currently inside .LIB LOW"],
  ["Netlist error in file bogoLib1 at or near line 12",
   ".ENDL encountered with name LOW, which does not match .LIB name NOM"],
  ["Netlist error in file bogoLib1 at or near line 17",
   ".ENDL encountered without .LIB"]
);

$retval = $Tools->runAndCheckGroupedError($CIRFILE,$XYCE,@searchstrings);

print "Exit code = $retval\n";
exit $retval;
