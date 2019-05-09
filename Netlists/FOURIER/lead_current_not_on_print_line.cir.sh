#!/usr/bin/env perl

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();
#$Tools->setDebug(1);
#$Tools->setVerbose(1);

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
use Scalar::Util qw(looks_like_number);

&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

# Comparison tolerances. 
# phase is output in degrees and for fourier components with very small magnitude, 
# it can be have several degrees of scatter.  Thus it gets its own abstol
my $absTol = 2.0e-6;
my $phaseAbsTol = 1.0;
my $relTol = 0.02;
my $zeroTol = 1.0e-8;

# change ending on gold standard file from ".prn" as passed in to ".gs" 
# which is the file storing the measure results.

$GOLDPRN =~ s/prn$/gs/;
$CIRFILE =~ s/\.cir$//; # remove the .cir at the end.
$FOURFILE = $CIRFILE . "_four.cir";

# Clean up droppings from any previous run in this directory.
#`rm -f $FOURFILE.prn $FOURFILE.four.`;

if (defined($verbose)) { $Tools->setVerbose(1); }

sub verbosePrint { $Tools->verbosePrint(@_); }

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$FOURFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$FOURFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl

if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $FOURFILE junk $FOURFILE.prn > $FOURFILE.prn.out 2>&1 $FOURFILE.prn.err"))
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

#
# Did we make a Fourier file
#
if (not -s "$FOURFILE.four" ) { print "Exit code = 17\n"; exit 17; }

# Now look for the .four output file and compare it to the gold standard 
open(RESULTS, "$FOURFILE.four");
open(GOLD_STD, $GOLDPRN);

$lineCount=0;
# Compare all data, including all header information
while( ($line=<RESULTS>) && ($line_gs=<GOLD_STD>) )
{
  $lineCount++;
  # process a result line into text and values.
  chop $line;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line =~ s/^\s*//;
  @lineOfDataFromXyce = (split(/[\s,]+/, $line));
  
  # process a line_gs into text and values.
  chop $line_gs;
  $line_gs =~ s/^\s*//;
  @gsLineOfDataFromXyce = (split(/[\s,]+/, $line_gs));
  
  if ($#lineOfDataFromXyce != $#gsLineOfDataFromXyce)
  {
    print "Xyce's Fourier file doesn't match the gold standard\n";
    print "Xyce's Fourier output: $line\n";
    print "Gold Standard: $line_gs\n";
    $retval=2;
  }
  else
  {
    # the two files have the same number of items on a line.  
    # compare individual values as scalars  This will have the 
    # effect of 
    for( $i=0; $i<=$#lineOfDataFromXyce; $i++ )
    {
      if ( looks_like_number($lineOfDataFromXyce[$i]) && looks_like_number($gsLineOfDataFromXyce[$i]) )
      {
        if( ( abs( $lineOfDataFromXyce[$i] ) < $zeroTol ) && ( abs( $gsLineOfDataFromXyce[$i] ) < $zeroTol ) )
        {
           #print "number compare below zeroTol $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i] ok\n";
        }
        elsif( looks_like_number($lineOfDataFromXyce[0]) && (($i==3) || ($i==5)) && 
               ( abs( $lineOfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $phaseAbsTol ) ) 
        {
           # phase needs different handling, but all lines with phase values only have numbers
           # on that line
           #print "Phase comparison passed $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i]\n";
        }
        elsif ( abs( $lineOfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $absTol )
        {
           # regular compare
        }
        else
        {
          print "$FOURFILE.four and $GOLDPRN found a numeric difference\n";
          print "Comparing Fourier data \"$lineOfDataFromXyce[$i]\" to GS data \"$gsLineOfDataFromXyce[$i]\" as ";
          print "Failed numeric compare\n";
          $retval=2;
          last;
        }
      }
      elsif ($lineOfDataFromXyce[$i] eq $gsLineOfDataFromXyce[$i]) 
      {
        # same in string context so ok.
        #print "string compare of $lineOfDataFromXyce[$i] and $gsLineOfDataFromXyce[$i] ok\n";
      }
      else
      {
        print "Elements failed compare:\n";
        print "Xyce Fourier produced: \"$lineOfDataFromXyce[$i]\"\n";
        print "Gold standard: \"$gsLineOfDataFromXyce[$i]\"\n";
        $retval=2;
        last;
      }
    
    }
  
  }
}
close(RESULTS);
close(GOLD_STD);

# test the return code
if ( $retval != 0 )
{
  verbosePrint "test Failed!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}
elsif ($lineCount == 0)
{
  # sanity check, whether we actually read in gold data
  $retval=2;
  print "Zero lines read from Gold Standard\n";
  verbosePrint "test Failed!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}
else
{
  print "Successfully tested lead current requests from .FOUR lines\n";
}

# now test that the current request (I(V2)) from the 
# .MEASURE statement worked.
if (not -s "$FOURFILE.mt0" ) 
{
  print "Did not find .mt0 file\n"; 
  print "Exit code = 17\n"; exit 17;
}

# hard-coded that there are two measures in the file,
# and that the first measure has a value of 2, while
# the second measure has a value of 1.
$calcVals[0]=2;
$calcVals[1]=1;

# get the measure results from the .mt0 file
open(MEASRESULTS, "$FOURFILE.mt0");
while( $line=<MEASRESULTS> )
{
  if( $line =~ /=/ )
  { 
    # This works for all measures but FOUR 
    # parse out NAME = Value 
    chop $line;
    ($name,$sep,$value) = split(/ /, $line);
    push @measureNames, $name;
    push @measureVals, $value;
    $numMeasuresFound++;
  }
}
close(MEASRESULTS);

# use different tolerances for the measure results, based on what's
# typically used in the regression tests for .MEASURE
$absMeasTol = 1.0e-4;
$relMeasTol = 0.02;
if ($numMeasuresFound != 2)
{
  $retval = 2; 
}
else
{
  for $idx (0 ..1)
  {
    $absMeasureError = abs( $measureVals[$i] - $calcVals[$i] );
    $relMeasureError = abs( $absMeasureError / $calcVals[$i] );
    if( (abs($absMeasureError) > $absMeasTol) || ( (abs($measureVals[$i]) > $zeroTol) && 
        (abs($relMeasureError) > $relMeasTol) ) )
    {
       print "Out of tolerance for measure $measureNames[$idx] with abstol = $absTol and reltol = $relTol \n";
       print "  measure value = $measureVals[$i], expected value = $calcVals[$i]\n";
       print "  Absolute and relative errors were: $absMeasureError and $relMeasureError\n";
       $retval = 2;
       last;
    }
  }
}

if ( $retval!= 0 )
{
  verbosePrint "test Failed!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}
else
{
  print "Successfully tested lead current request from .MEASURE line\n";
}

# now make sure that the lead current request from the .PRN line (I(V1)) has the right max value
# parse the data from the .PRN file into an array
open(PRN_DATA, "$FOURFILE.prn");
$numPts=0;
while( $line=<PRN_DATA> )
{
  if( $line =~ /TIME/)
  {  
    # ignore first line
  }
  elsif($line =~ /End of/)
  {
    # end of Xyce simulation line 
    # do nothing in this case
  }
  else
  {
    # save var values 
    chop $line;
    # Remove leading spaces on line, otherwise the spaces become element 0
    # of "@lineOfDataFromXyce" instead of the first column of data.
    $line =~ s/^\s*//;
    @lineOfDataFromXyce = (split(/\s+/, $line));
    for ($varNum=0; $varNum <= $#lineOfDataFromXyce; $varNum++)
    {
      $dataFromXyce[$numPts][$varNum] = $lineOfDataFromXyce[$varNum];
    }
    $numPts++;
  }
}
close(PRN_DATA); 

# this code is similar to how the MAX measure is tested in the MEASURE
# regression tests.
$firstValue = 0;
$maxVal = 0;
$colIdx=2;
for $i (0 .. $#dataFromXyce )
{
  if ($firstValue==0)
  {
    $firstValue=1;
    $maxVal = $dataFromXyce[$i][$colIdx];
  }
  elsif ($dataFromXyce[$i][$colIdx] > $maxVal)
  {
    $maxVal = $dataFromXyce[$i][$colIdx];
  }
}  

# max value should be the same as the pre-coded max value set above for I(V1) (e.g., 2)
$absMeasureError = abs( $maxVal - $calcVals[0] );
$relMeasureError = abs( $absMeasureError / $calcVals[0] );
if( (abs($absMeasureError) > $absMeasTol) || ( (abs($measureVals[$i]) > $zeroTol) && 
    (abs($relMeasureError) > $relMeasTol) ) )
{
  print "Out of tolerance for comparing .prn file with expected max with abstol = $absTol and reltol = $relTol \n";
  print "  prn value = $maxVal, expected value = $calcVals[0]\n";
  print "  Absolute and relative errors were: $absMeasureError and $relMeasureError\n";
  $retval = 2;
}

if ( $retval != 0 )
{
  verbosePrint "test Failed!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}
else
{
  print "Successfully tested lead current request from .PRINT TRAN line\n";
}

#success if we made it here
verbosePrint "test Passed!\n";
print "Exit code = $retval\n"; 
exit $retval;


