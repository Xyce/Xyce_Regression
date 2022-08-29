#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script  (This is NEVER used and can be ignored)
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

# This test simply checks that Xyce issues appropriate warnings

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3]; 

# check various error cases
# this string should be in the warning messages of this Xyce run  
@searchstrings = ( "Device model PCH.2: Model card specifies BSIM4 version 4.8 which is newer",
                   " Device model NCH.2: Model card specifies BSIM4 version 4.65 not supported by",
                   " Device model NCH.2: Parameter TEMPEOT not valid for device of version 4.61.",
                   "Device model NCH.1: Model card specifies BSIM4 version 4.5 which is older",
                   " Device model NCH.1: Parameter TEMPEOT not valid for device of version 4.61."
                 );

print "Checking warning messages for DC measure line\n";
$retval = $Tools->runAndCheckWarning($CIRFILE,$XYCE,@searchstrings);

if ($retval != 0)
{
  print "Exit code = $retval\n"; 
  exit $retval;
}

print "Exit code = 0\n";
exit 0;



