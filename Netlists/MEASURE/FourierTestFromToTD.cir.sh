#!/usr/bin/env perl

use XyceRegression::Tools;
use MeasureCommon;

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

use Scalar::Util qw(looks_like_number);

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

# these are the tolerances used in comparing the measures calculated by this 
# script to those calculated by Xyce.  Zerotol is needed because some measured
# values should be zero (and reltol won't make sense in that case).

# phase is output in degrees and for fourier components with very small magnitude, 
# it can be have several degrees of scatter.  Thus it gets its own abstol
my $phaseAbsTol = 1.0;
my $relTol = 0.01;
my $zeroTol = 1.0e-8;
my $doubleCount=0;
my $expectedDoubleCount=102;
my $defaultPrecision=6;

# change ending on gold standard file from ".prn" as passed in to ".mt0" 
# which is the file storing the measure results.

$GOLDPRN =~ s/prn$/mt0/;

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

#
# Did we make a measure file
#
if (not -s "$CIRFILE.mt0" ) { print "Exit code = 17\n"; exit 17; }

#
# Now we need to count the number of .MEASURE statemets in the netlist
# and make sure we have some output for each one in the output file
#
open(NETLIST, "$CIRFILE");
$numMeasures=0;
while( $line=<NETLIST> )
{
  if( $line =~ /^\.measure/i)
  {  
    $numMeasures++;
    @words = split( /\s+/, $line);
    @measureNames[ $numMeasures-1 ] = $words[2];
  }
}
close(NETLIST);

#
# Make sure the measurement was not output multiple times in parallel
# in either the output file or the measure file.
for (my $i=0; $i < $numMeasures; $i++) 
{
   $numMeasOut = `grep -ic $measureNames[ $i ] $CIRFILE.out`;
   if ( $numMeasOut != 1 )
   {
     print "Xyce printed out $measureNames[ $i ] measure to standard output multiple times.\n";
     $retval = 2;
   }
   $numMeasMT0 = `grep -ic $measureNames[ $i ] $CIRFILE.mt0`;
   if ( $numMeasMT0 != 1 )
   {
     print "Xyce printed out $measureNames[ $i ] measure to file multiple times.\n";
     $retval = 2;
   }
}

if ( $retval != 0 )
{
  print "Exit code = $retval\n"; 
  exit $retval;
}
  
#
# Now look for the measure output file and compare it to a 
# gold standard line by line.
#
open(RESULTS, "$CIRFILE.mt0");
open(GOLD_STD, $GOLDPRN);
$lineNumber=1;
$retval = -1;
while( ($line=<RESULTS>) && ($line_gs=<GOLD_STD>) )
{
  $retval=0 if $retval==-1;
  # process a line into text and values.
  chop $line;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line =~ s/^\s*//;
  @lineOfDataFromXyce = (split(/[\s,]+/, $line));
  #print "line of data from Xyce = @lineOfDataFromXyce\n";
  #print "end count = $#lineOfDataFromXyce\n";
  
  # process a line_gs into text and values.
  chop $line_gs;
  $line_gs =~ s/^\s*//;
  @gsLineOfDataFromXyce = (split(/[\s,]+/, $line_gs));
  
  if( $#lineOfDataFromXyce != $#gsLineOfDataFromXyce )
  {
    print "Xyce's output to measure file doesn't match the gold standard at line $lineNumber\n";
    print "Xyce's output: $line\n";
    print "Gold Standard: $line_gs\n";
    $retval=2;
  }
  else
  {
    # the two files have the same number of items on a line.  
    # compare individual values as scalars  This will have the 
    # effect fo 
    for( $i=0; $i<=$#lineOfDataFromXyce; $i++ )
    {
      #print "data item = $lineOfDataFromXyce[$i]\n";
      if (looks_like_number($lineOfDataFromXyce[$i]) && looks_like_number($gsLineOfDataFromXyce[$i] ) )
      {
        if( ( abs( $lineOfDataFromXyce[$i] ) < $zeroTol) &&  (abs( $gsLineOfDataFromXyce[$i] ) < $zeroTol ))
        {
           # print "number compare below zeroTol $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i] ok\n";
        }
        elsif( (($i==3) || ($i==5)) && (abs( $lineOfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $phaseAbsTol )) 
        {
           # phase needs different handling
           # print "Phase comparison passed $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i]\n";
        }
        elsif( ( (abs( $lineOfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ))/abs($gsLineOfDataFromXyce[$i]) < $relTol )) 
        {
           # regular compare
	   # print "number comparison passed $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i]\n";
        }
        else
        {
          print "On line $lineNumber of $CIRFILE.mt0 and $GOLDPRN found a numeric difference\n";
          print "Comparing Xyce's \"$lineOfDataFromXyce[$i]\" to GS \"$gsLineOfDataFromXyce[$i]\" as ";
          print "Failed numeric compare\n";
          $retval=2;
          last;
        }
        if( $lineOfDataFromXyce[$i] =~ /e/)
        {
	  $doubleCount++;
          $retval = MeasureCommon::checkNumberFormat($lineOfDataFromXyce[$i],1,$defaultPrecision);
          if ( $retval != 0 )
          {
            print "test Failed because of number format!\n";
            print "Exit code = $retval\n";
            exit $retval;
          }
        }
      }
      elsif( $lineOfDataFromXyce[$i] eq $gsLineOfDataFromXyce[$i] )
      {
        # same in string context so ok.
        # print "string compare of $lineOfDataFromXyce[$i] ok\n";
      }
      else
      {
        print "Elements failed compare on line $lineNumber: \n";
        print "Xyce produced: \"$lineOfDataFromXyce[$i]\"\n";
        print "Gold standard: \"$gsLineOfDataFromXyce[$i]\"\n";
        $retval=2;
        last;
      }
    
    }
  
  }
  $lineNumber++;
}
close(RESULTS);
close(GOLD_STD);

if ( $doubleCount != $expectedDoubleCount )
{
  print "Found $doubleCount doubles.  Expected $expectedDoubleCount doubles.\n";
  $retval=2; 
}

if ( $retval != 0 )
{
  print "Exit code = $retval\n"; 
  exit $retval;
}
else
{
  # Now check re-measure.  This is slightly different for FOUR
  use File::Copy;
  move("$CIRFILE.mt0","$CIRFILE.temp.mt0");

  # here is the command to run xyce with remeasure
  my $CMD="$XYCE -remeasure $CIRFILE.prn $CIRFILE > $CIRFILE.remeasure.out";
  $retval=system($CMD)>>8;
  
  if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
  if (not -s "$CIRFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

  # Did we make a measure file
  if (not -s "$CIRFILE.mt0" ) { print "Exit code = 17\n"; exit 17; }

  # rename the files
  move("$CIRFILE.mt0","$CIRFILE.remeasure.mt0");
  move("$CIRFILE.temp.mt0","$CIRFILE.mt0");

  # use file_compare since the .mt0 file for FOUR has a different format than the other measures
    my $dirname = `dirname $XYCE_VERIFY`;
    chomp $dirname;
    my $fc = "$dirname/file_compare.pl";
    `$fc $CIRFILE.remeasure.mt0 $CIRFILE.mt0 $phaseAbsTol $relTol $zeroTol > $CIRFILE.remeasure.mt0.out 2> $CIRFILE.remeasure.mt0.err`;  
    $retval=$? >> 8;
}

print "Exit code = $retval\n"; 
exit $retval;


