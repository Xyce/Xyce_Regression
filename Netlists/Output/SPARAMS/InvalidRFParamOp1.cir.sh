#!/usr/bin/env perl

use XyceRegression::Tools;
$Tools = XyceRegression::Tools->new();

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
# output from comparison to go into $CIRFILE.raw.out and the STDERR output from
# comparison to go into $CIRFILE.raw.err.

use Getopt::Long;
&GetOptions( "verbose!" => \$verbose );
if (defined($verbose)) { $Tools->setVerbose(1); }

$XYCE=$ARGV[0];
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

# these strings should be in the output of this failed Xyce run
@searchstrings = ("Netlist error: Indices for SR\\(1,2\\) operator must be <= number of ports",
                  "Netlist error: Indices for SI\\(1,2\\) operator must be <= number of ports",
                  "Netlist error: Indices for YM\\(1,2\\) operator must be <= number of ports",
                  "Netlist error: Indices for YP\\(1,2\\) operator must be <= number of ports",
                  "Netlist error: Indices for ZDB\\(1,2\\) operator must be <= number of ports",
                  "Netlist error: Indices for SR\\(2,1\\) operator must be <= number of ports",
                  "Netlist error: Indices for SI\\(2,1\\) operator must be <= number of ports",
                  "Netlist error: Indices for YM\\(2,1\\) operator must be <= number of ports",
                  "Netlist error: Indices for YP\\(2,1\\) operator must be <= number of ports",
                  "Netlist error: Indices for ZDB\\(2,1\\) operator must be <= number of ports");
$retval = $Tools->runAndCheckError($CIRFILE,$XYCE,@searchstrings);

print "Exit code = $retval\n"; exit $retval;


