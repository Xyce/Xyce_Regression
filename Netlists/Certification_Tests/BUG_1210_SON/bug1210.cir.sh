#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);
#$Tools->setVerbose(1);

# The input arguments to this script are: 
# $1 = location of Xyce binary
# $2 = location of xyce_verify.pl script
# $3 = location of compare script 
# $4 = location of circuit file to test
# $5 = location of gold standard prn file

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

# these are the tolerances used in comparing the measures calculated by this 
# script to those calculated by Xyce.  Zerotol is needed because some measured
# values should be zero (and reltol won't make sense in that case).

my $absTol = 3.0e-3;
my $relTol = 0.02;
my $zeroTol = 1.0e-5;

if (defined($verbose)) { $Tools->setVerbose(1); }

sub verbosePrint { $Tools->verbosePrint(@_); }

$retval = -1;
$paramsFile = "paramfile.txt";
$responseFile = "results.txt";
# have to call Xyce manually here to stick in extra args
$CMD="$XYCE -prf $paramsFile -rsf $responseFile $CIRFILE > $CIRFILE.out";
$retval=system($CMD)>>8;

if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }
#
# Did we make a measure file
#
if (not -s "$CIRFILE.mt0" ) { print "Exit code = 17\n"; exit 17; }


# call xyce_verify on the output prn file.  If the negative sign on the 
# input param file was ignored, then the output will disagree with the 
# gold standard.
$CMD="$XYCE_VERIFY $CIRFILE $GOLDPRN $CIRFILE.prn > $CIRFILE_verify.out";
$retval=system($CMD)>>8;



if ( $retval != 0 )
{
  verbosePrint "test Failed!\n";
  print "Exit code = 2\n"; 
  exit $retval;
}
  
verbosePrint "test Passed!\n";
print "Exit code = $retval\n"; 
exit $retval;
