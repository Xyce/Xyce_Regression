#!/usr/bin/env perl

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

# Since the shell script runs Xyce also, it is responsible for capturing any
# error output from Xyce.  The script run_xyce_regression captures the test
# output and handles the resulting files.  

$XYCE=$ARGV[0];
#$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

$CMD="$XYCE $CIRFILE > $CIRFILE.out 2> $CIRFILE.err";
if (system("$CMD") != 0) { print "Exit code = 10\n"; exit 10; }

open(outfile,"$CIRFILE.out") or die "Error:  Cannot open $CIRFILE.out\n";
$dayOfWeek=`date +%a`;
$thisYear=`date +%Y`;
chomp($dayOfWeek);
chomp($thisYear);
while ($line = <outfile>)
{
  # Look for a line that starts with the day of the week and ends with the year
  if ( $line =~ m/^\** Date: $dayOfWeek .*$thisYear\s*$/ ) 
  { 
      print "Exit code = 0\n"; 
      exit 0; 
  }
}
close(outfile);
print "Exit code = 2\n"; exit 2;

