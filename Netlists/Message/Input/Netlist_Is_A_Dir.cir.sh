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

@searchstrings = ( "Could not open netlist file ."
);

&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
#$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];
$OUTFILE="NetlistName_dir.txt";

$netlist_dir_output=system("$XYCE . > $OUTFILE 2>/dev/null");

$retval=$Tools->checkError( $OUTFILE, @searchstrings );
if ($retval != 0) {
  print "Using a directory path instead of a netlist filename did not elicit an error\n";
} 

print "Exit code = $retval\n";
exit $retval


