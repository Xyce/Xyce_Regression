#!/usr/bin/env perl

use XyceRegression::Tools;
$Tools = XyceRegression::Tools->new();

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script  (This is NEVER used and can be ignored)
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3]; 
$GOLDPRN=$ARGV[4];

# check various error cases
# this string should be in the output of this failed Xyce run 
# Note that parens are escaped with \\ 
@searchstrings = ("Netlist error: Function or variable V\\(BOGO1\\) is not defined",
                  "Netlist error: Function or variable V\\(BOGO2\\) is not defined",
                  "Netlist error: Function or variable V\\(GND\\) is not defined",
                  "Netlist error: Function or variable V\\(BOGO3\\) is not defined",
                  "Netlist error: Function or variable V\\(BOGO4\\) is not defined",
                  "Netlist error: Function or variable V\\(BOGO5\\) is not defined",
                  "Netlist error: Function or variable N\\(BOGO6\\) is not defined",
                  "Netlist error: Function or variable VR\\(BOGO7\\) is not defined",
                  "Netlist error: Function or variable VI\\(BOGO8\\) is not defined",
                  "Netlist error: Function or variable VP\\(BOGO9\\) is not defined",
                  "Netlist error: Function or variable VM\\(BOGO9\\) is not defined",
                  "Netlist error: Function or variable VDB\\(BOGO10\\) is not defined",
                  "Netlist error: Function or variable VR\\(A,BOGO11\\) is not defined",
                  "Netlist error: Function or variable VI\\(BOGO12,A\\) is not defined",
                  "Netlist error: Function or variable VP\\(B,BOGO13\\) is not defined",
                  "Netlist error: Function or variable VM\\(BOGO14,B\\) is not defined",
                  "Netlist error: Function or variable VDB\\(A,BOGO15\\) is not defined"
);

$retval = $Tools->runAndCheckError($CIRFILE,$XYCE,@searchstrings);
print "Exit code = $retval\n"; exit $retval; 
