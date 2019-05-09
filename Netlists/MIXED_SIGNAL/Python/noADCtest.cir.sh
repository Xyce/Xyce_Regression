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
# Otherwise we return the exit code of compare or xyce_verify.pl

# Since the shell script runs Xyce and the comparison program, it is
# responsible for capturing any error output from Xyce and the STDOUT & STDERR
# from the comparison program.  The outside script, run_xyce_regression,
# expects the STDERR output from Xyce to go into $CIRFILE.err, the STDOUT
# output from comparison to go into $CIRFILE.prn.out and the STDERR output from
# comparison to go into $CIRFILE.prn.err.  

use Getopt::Long;

&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

# python file
$PYFILE=$CIRFILE;
$PYFILE =~s/cir/py/;

# find root of Xyce build directory
$XYCE_BASE = $XYCE;

# remove files from previous runs
system("rm -f $CIRFILE.out $CIRFILE.prn");

$XYCE_LIB_DIR="";

# set the environment variables
$LD_LIBRARY_PATH=$ENV{'LD_LIBRARY_PATH'}; 

if($XYCE_BASE =~ s/\/src\/Xyce$// )
{ # uninstalled copy of Xyce.  Look for extra libraries in utils/XyceCInterface directory
  $XYCE_BASE =~ s/\/src\/Xyce$//;
  $LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$XYCE_BASE/utils/XyceCInterface/.libs";
  $XYCE_LIB_DIR="$XYCE_BASE/utils/XyceCInterface/.libs";
}
if($XYCE_BASE =~ s/\/bin\/Xyce$// )
{
  # installed copy of Xyce look for libraries in lib directory
  $XYCE_BASE =~ s/\/bin\/Xyce$//;
  $LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$XYCE_BASE/lib";
  $XYCE_LIB_DIR="$XYCE_BASE/lib";
}
$ENV{'LD_LIBRARY_PATH'} = $LD_LIBRARY_PATH;
print "setting ld library path to $LD_LIBRARY_PATH\n";

$retval=0;
# run the netlist via the Python version of XyceCInterface
$retval = system("python $PYFILE $XYCE_LIB_DIR > $CIRFILE.out");
if ($retval != 0)
{
  print "Netlist failed to initialize via Python-based XyceCInterface\n";
  print "Exit code = 2\n"; exit 2;
}

# Note: the .py file does not actually run the simulation, so there is no 
# output .prn file made.

# check for XyceCInterface return codes and other info in stdout
@searchstrings = ("return value from initialize is 1",
                  "return value from getNumDevices is 0",
                  "Num devices and max device name length are 0 0",
                  "Netlist warning: No devices from model group YADC found in netlist",
                  "return value from getDeviceNames is 0",
                  "\\[\\]",
                  "Netlist warning: setADCWidths\\(\\) called with empty list of ADC names",
                  "return value from setADCWidths is 0",
                  "Netlist warning: getADCWidths\\(\\) called with empty list of ADC names",
                  "return value from getADCWidths is 0",
                  "\\[\\]",
                  "return value from getADCMap is 0",
                  "\\[\\]",
                  "\\[\\]",
                  "\\[\\]",
                  "\\[\\]",
                  "\\[\\]",
                  "\\[\\]",
                  "return value from getTimeVoltagePairsADC is 0",
                  "number of ADC names returned by getTimeVoltagePairsADC is 0",
                  "number of points returned by getTimeVoltagePairsADC is 0",
                  "return value from getTimeStatePairsADC is 0",
                  "number of ADC names returned by getTimeStatePairsADC is 0",
                  "number of points returned by getTimeStatePairsADC is 0",
                  "xyce_close after delete xycePtr"
);
if ( $Tools->checkError("$CIRFILE.out",@searchstrings) != 0) 
{
 print "Failed to find all of the correct XyceCInterface information in stdout\n"; 
 $retval = 2; 
}

print "Exit code = $retval\n"; exit $retval;

