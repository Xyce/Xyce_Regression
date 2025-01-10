#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();

# The input arguments to this script are: 
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script 
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3];

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

#
# now based on the prn file, make a comparison file

# When properly executed, the output's 3rd column should equal the sum
# of the 4th and 5th columns, and the 6th colum should be equal to the
# sum of the 7th and 8th.  We generate a fake "gold standard" where this
# is forced to be true, and use it with xyce_verify to assure that the
# real output is correct to within tolerances.

open(INPUT,"$CIRFILE.prn");
open(OUTPUT,">$CIRFILE.prn.gs");
while ($line = <INPUT>)
{
  # Handle first and last lines:
  if ($line =~ m/^[IE]/) 
  { 
    print OUTPUT "$line"; 
    next; 
  }
  @s = split(" ",$line);
  $a = 0;
  printf OUTPUT "%3d   %14.8e   %14.8e   %14.8e   %14.8e   %14.8e   %14.8e   %14.8e   \n",$s[0],$s[1],$s[3]+$s[4],$s[3],$s[4],$s[6]+$s[7],$s[6],$s[7];
}
close(INPUT);
close(OUTPUT);

#
# call xyce-verify to compare result to generated gold standard.
#
my $CMD="$XYCE_VERIFY $CIRFILE $CIRFILE.prn.gs $CIRFILE.prn > $CIRFILE.prn.out 2>$CIRFILE.prn.err";
$retval = system("$CMD");
# lower byte is not relevent here.  xyce_verify's return code is in
# the upper byte to shift it 8 bits.
$retval = $retval >> 8;
if( $retval == 20 )
{
  # xyce_verify return codes are different than what run_xyce_regression expects 
  # A return of 20 from xyce_verify is failed compare. So return that as "2" to 
  # run_xyce_regression so it can print a meaningful error. 
  $retval = 2
}
if ($retval != 0) 
{ 
  print "Exit code = $retval\n"; 
  exit $retval; 
}
print "Exit code = 0\n"; 
exit 0;


