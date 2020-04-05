#!/usr/bin/env perl

use XyceRegression::Tools;
$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script  (This is NEVER used and can be ignored)
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

use Getopt::Long;
&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3]; 
$GOLDPRN=$ARGV[4];

if (defined($verbose)) { $Tools->setVerbose(1); }

# check various error cases
# this string should be in the output of this failed Xyce run  
@searchstrings = (
"Netlist error in file unsupported_dc_measure_types.cir at or near line 25",
  "Only AVG, DERIV, EQN/PARAM, ERR, ERR1, ERR2, ERROR, FIND, INTEG, MIN, MAX,",
  "PP, RMS and WHEN measure types are supported for DC measure mode",
"Netlist error in file unsupported_dc_measure_types.cir at or near line 26",
  "Only AVG, DERIV, EQN/PARAM, ERR, ERR1, ERR2, ERROR, FIND, INTEG, MIN, MAX,",
  "PP, RMS and WHEN measure types are supported for DC measure mode",
"Netlist error in file unsupported_dc_measure_types.cir at or near line 27",
  "Only AVG, DERIV, EQN/PARAM, ERR, ERR1, ERR2, ERROR, FIND, INTEG, MIN, MAX,",
  "PP, RMS and WHEN measure types are supported for DC measure mode",
"Netlist error in file unsupported_dc_measure_types.cir at or near line 28",
  "Only AVG, DERIV, EQN/PARAM, ERR, ERR1, ERR2, ERROR, FIND, INTEG, MIN, MAX,",
  "PP, RMS and WHEN measure types are supported for DC measure mode",
"Netlist error in file unsupported_dc_measure_types.cir at or near line 29",
  "Only AVG, DERIV, EQN/PARAM, ERR, ERR1, ERR2, ERROR, FIND, INTEG, MIN, MAX,",
  "PP, RMS and WHEN measure types are supported for DC measure mode",
"Netlist error in file unsupported_dc_measure_types.cir at or near line 30",
  "Only AVG, DERIV, EQN/PARAM, ERR, ERR1, ERR2, ERROR, FIND, INTEG, MIN, MAX,",
  "PP, RMS and WHEN measure types are supported for DC measure mode"
);

$retval = $Tools->runAndCheckError($CIRFILE,$XYCE,@searchstrings);
print "Exit code = $retval\n"; exit $retval; 
