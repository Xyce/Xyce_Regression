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

# This string should be in the output of this failed Xyce run.
# Note: double escaping dot (\\.) matches a single dot rather 
# than any single character.
@searchstrings = ("Cannot create Save File \\.");

$retval = $Tools->runAndCheckError($CIRFILE,$XYCE,@searchstrings);
print "Exit code = $retval\n"; exit $retval; 
