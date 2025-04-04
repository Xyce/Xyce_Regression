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
$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

# these search strings are supposed to occur in the error output
# for the netlist ParameterBlock_extractMIDeviceData1.cir.
@searchstrings = (["Netlist error in file Core_SourceData_extractSourceData.cir at or near line 6",
    "Line for device V1 is missing a value or expression after DC field"],
   ["Netlist error in file Core_SourceData_extractSourceData.cir at or near line 9",
    "Line for device I2 is missing a value or expression after DC field"],
   ["Netlist error in file Core_SourceData_extractSourceData.cir at or near line 12",
    "Invalid DC value \"V\" for device V3"],
   ["Netlist error in file Core_SourceData_extractSourceData.cir at or near line 15",
    "Invalid DC value \"A\" for device I4"]
);

$retval = $Tools->runAndCheckGroupedError($CIRFILE,$XYCE,@searchstrings);
print "Exit code = $retval\n";
exit $retval;

