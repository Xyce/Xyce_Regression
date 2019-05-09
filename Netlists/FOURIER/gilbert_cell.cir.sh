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
$MEASUREFILE = $CIRFILE . "_measure.cir";
$FOURFILE = $CIRFILE . "_four.cir";

if (defined($verbose)) { $Tools->setVerbose(1); }

sub verbosePrint { $Tools->verbosePrint(@_); }

$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$MEASUREFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$MEASUREFILE.prn" ) { print "Exit code = 14\n"; exit 14; }

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl

if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $MEASUREFILE junk $MEASUREFILE.prn > $MEASUREFILE.prn.out 2>&1 $MEASUREFILE.prn.err"))
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
# Did we make a measure file
#
if (not -s "$MEASUREFILE.mt0" ) { print "Exit code = 17\n"; exit 17; }

#
# Did we make a Fourier file
#
if (not -s "$FOURFILE.four" ) { print "Exit code = 17\n"; exit 17; }

# Now look for the measure output file and compare it to a 
# gold standard line by line.
#
open(RESULTS, "$MEASUREFILE.mt0");
open(RESULTS2, "$FOURFILE.four");
open(GOLD_STD, $GOLDPRN);

# Advance each of these files to where the results are, bypass the header information.
$retval = 2;
while( $line=<RESULTS> )
{
  # process a line into text and values.
  chop $line;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line =~ s/^\s*//;
  @lineOfDataFromXyce = (split(/[\s,]+/, $line));
  if ( $lineOfDataFromXyce[0] eq 'Harmonic' )
  {
    $retval = 0;
    last;
  }
}
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }

$retval = 2;
while( $line2=<RESULTS2> )
{
  # process a line into text and values.
  chop $line2;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line2 =~ s/^\s*//;
  @lineOfDataFromXyce = (split(/[\s,]+/, $line2));
  if ( $lineOfDataFromXyce[0] eq 'Harmonic' )
  {
    $retval = 0;
    last;
  }
}
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }

$retval = 2;
while( $line_gs=<GOLD_STD> )
{
  # process a line into text and values.
  chop $line_gs;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line_gs =~ s/^\s*//;
  @lineOfDataFromXyce = (split(/[\s,]+/, $line_gs));
  if ( $lineOfDataFromXyce[0] eq 'Harmonic' )
  {
    $retval = 0;
    last;
  }
}
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }

# Now compare data from this point on.
while( ($line=<RESULTS>) && ($line2=<RESULTS2>) && ($line_gs=<GOLD_STD>) )
{
  # process a line into text and values.
  chop $line;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line =~ s/^\s*//;
  @lineOfDataFromXyce = (split(/[\s,]+/, $line));
  
  # process a line into text and values.
  chop $line2;
  # Remove leading spaces on line, otherwise the spaces become 
  # element 0 of "@lineOfDataFromXyce" instead of the first column of data.
  $line2 =~ s/^\s*//;
  @line2OfDataFromXyce = (split(/[\s,]+/, $line2));
  
  # process a line_gs into text and values.
  chop $line_gs;
  $line_gs =~ s/^\s*//;
  @gsLineOfDataFromXyce = (split(/[\s,]+/, $line_gs));
  
  if( ($#lineOfDataFromXyce != $#gsLineOfDataFromXyce) || ($#line2OfDataFromXyce != $#gsLineOfDataFromXyce) )
  {
    print "Xyce's measure or Fourier file doesn't match the gold standard\n";
    print "Xyce's measure output: $line\n";
    print "Xyce's Fourier output: $line2\n";
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
      if (looks_like_number($lineOfDataFromXyce[$i]) && looks_like_number($line2OfDataFromXyce[$i]) && looks_like_number($gsLineOfDataFromXyce[$i] ) )
      {
        if( (abs( $lineOfDataFromXyce[$i] ) < $zeroTol) && (abs( $line2OfDataFromXyce[$i] ) < $zeroTol) &&  (abs( $gsLineOfDataFromXyce[$i] ) < $zeroTol ))
        {
           #print "number compare below zeroTol $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i] ok\n";
        }
        elsif( (($i==3) || ($i==5)) && (abs( $lineOfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $phaseAbsTol ) && (abs( $line2OfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $phaseAbsTol )) 
        {
           # phase needs different handling
           #print "Phase comparison passed $lineOfDataFromXyce[$i] , $gsLineOfDataFromXyce[$i]\n";
        }
        elsif( (abs( $lineOfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $absTol ) && (abs( $line2OfDataFromXyce[$i] - $gsLineOfDataFromXyce[$i] ) < $absTol )) 
        {
           # regular compare
        }
        else
        {
          print "$MEASUREFILE.mt0, $FOURFILE.four and $GOLDPRN found a numeric difference\n";
          print "Comparing Xyce's measure data \"$lineOfDataFromXyce[$i]\" and Fourier data \"$line2OfDataFromXyce[$i]\" to GS data \"$gsLineOfDataFromXyce[$i]\" as ";
          print "Failed numeric compare\n";
          $retval=2;
          last;
        }
      }
      elsif( ($lineOfDataFromXyce[$i] eq $gsLineOfDataFromXyce[$i]) && ($line2OfDataFromXyce[$i] eq $gsLineOfDataFromXyce[$i]) )
      {
        # same in string context so ok.
        # print "string compare ok\n";
      }
      else
      {
        print "Elements failed compare:\n";
        print "Xyce measure produced: \"$lineOfDataFromXyce[$i]\"\n";
        print "Xyce Fourier produced: \"$line2OfDataFromXyce[$i]\"\n";
        print "Gold standard: \"$gsLineOfDataFromXyce[$i]\"\n";
        $retval=2;
        last;
      }
    
    }
  
  }
}
close(RESULTS);
close(RESULTS2);
close(GOLD_STD);

if ( $retval != 0 )
{
  verbosePrint "test Failed!\n";
  print "Exit code = $retval\n"; 
  exit $retval;
}
  
verbosePrint "test Passed!\n";
print "Exit code = $retval\n"; 
exit $retval;


