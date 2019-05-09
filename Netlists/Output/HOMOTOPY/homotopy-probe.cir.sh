#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);
#$Tools->setVerbose(1);

if (defined($verbose)) { $Tools->setVerbose(1); }

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

# Comparison tolerances
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-10;

$testFileName="$CIRFILE.HOMOTOPY.csd";
$goldFileName="$CIRFILE.GSfile";

# Clean up from any previous runs
`rm -f $testFileName $CIRFILE.prn $CIRFILE.err`;
`rm -f $CIRFILE.errmsg.out $CIRFILE.errmsg.err`; 

# create the output files
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);

# check that the homotopy files were made or exist
if (not -s "$goldFileName" ) 
{ 
  print STDERR "Missing Gold Standard file: $goldFileName\nExit code = 2\n"; 
  $exitCode=2; 
  print "test Failed!\n";
  print "Exit code = $exitCode\n";
  exit $exitCode;
}
if (not -s "$testFileName" ) 
{ 
  print STDERR "Missing Test file: $testFileName\nExit code = 14\n"; 
  $exitCode=14; 
  print "test Failed!\n";
  print "Exit code = $exitCode\n";
  exit $exitCode;
}
#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl
if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $CIRFILE $GOLDPRN $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
    {
        print "Exit code = 2 \n";
        exit 2;
    }
    else
    {
        print "Exit code = 0 \n";
        exit 0;
    }
}

# now compare the test and gold file .csd files
$fc = $XYCE_VERIFY;
$fc=~ s/xyce_verify/compare_csd_files/;
$CMD="$fc $testFileName $goldFileName $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval = system("$CMD");
# check the return value
if ( $retval != 0 )
{
  print "test Failed!\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "test passed!\n";
  print "Exit code = 0\n";
  exit 0;
}

