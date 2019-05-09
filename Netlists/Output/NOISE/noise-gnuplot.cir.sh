#!/usr/bin/env perl

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script 
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

# If Xyce does not produce the appropriate output files, then we return exit code 14.
# If Xyce succeeds, but the test fails, then we return exit code 2.
# If the shell script fails for some reason, then we return exit code 1.

# Since the shell script runs Xyce and the comparison program, it is
# responsible for capturing any error output from Xyce and the STDOUT & STDERR
# from the comparison program.  The outside script, run_xyce_regression,
# expects the STDERR output from Xyce to go into $CIRFILE.err, the STDOUT
# output from comparison to go into $CIRFILE.prn.out and the STDERR output from
# comparison to go into $CIRFILE.prn.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$GOLDPRN =~ s/\.prn$//; # remove the .prn at the end.

# remove old files if they exist
`rm -f $CIRFILE.NOISE.prn $CIRFILE.out $CIRFILE.err`;
`rm -f $CIRFILE.noise.prn.out $CIRFILE.noise.prn.err`;
`rm -f $CIRFILE.errmsg.out $CIRFILE.errmsg.err`;

# run Xyce
$CMD="$XYCE $CIRFILE > $CIRFILE.out 2> $CIRFILE.err";
$retval = system("$CMD");
if ($retval != 0) 
{
  if ($retval & 127)
  {
    print "Exit code = 13\n"; 
    printf STDERR "Xyce crashed with signal %d on file %s\n",($retval&127),$CIRFILE; 
    exit 13;
  }
  else
  {
    print "Exit code = 10\n"; 
    printf STDERR "Xyce exited with exit code %d on %s\n",$retval>>8,$CIRFILE;
    exit 10;
  }
}

if ( not -s "$CIRFILE.NOISE.prn") 
{
    print "Missing output file $CIRFILE.NOISE.prn\n";
    print "Exit code =14\n";
    exit 14;
}

# now check the .NOISE.prn file.  Use file_compare.pl because of the blank lines.
$absTol=1e-5;
$relTol=1e-3;
$zeroTol=1e-16;
$fc = $XYCE_VERIFY;
$fc=~ s/xyce_verify/file_compare/;
$CMD="$fc $CIRFILE.NOISE.prn $GOLDPRN.NOISE.prn $absTol $relTol $zeroTol > $CIRFILE.noise.prn.out 2> $CIRFILE.noise.prn.err";
$retval = system("$CMD");
if ($retval != 0)
{
  print "test Failed comparison of NOISE.prn file vs. gold NOISE.prn file!\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of NOISE.prn files\n";
}

# check that .out file exists, and open it if it does
if (not -s "$CIRFILE.out" ) 
{ 
  print "Exit code = 17\n"; 
  exit 17; 
}
else
{
  open(NETLIST, "$CIRFILE.out");
  open(ERRMSG,">$CIRFILE.errmsg") or die $!;
}

# parse the .out file to find the text related to .NOISE
$foundStart=0;
$foundEnd=0;
@outLine;
$lineCount=0;
while( $line=<NETLIST> )
{
  if ($line =~ /Total Output Noise/) { $foundStart = 1; }
  
  if ($foundStart > 0 && $foundEnd < 1)
  {
    print ERRMSG $line;
  }

  if ($foundStart > 0 && $line =~ /Total Input Noise/) { $foundEnd = 1; }   
}

close(NETLIST);
close(ERRMSG);

$GOLDSTDOUT="noise-gnuplot-gold-stdout"; 
$CMD="$fc $CIRFILE.errmsg $GOLDSTDOUT $absTol $relTol $zeroTol > $CIRFILE.errmsg.out 2> $CIRFILE.errmsg.err";
$retval = system("$CMD");
if ( $retval != 0 )
{
  print "test Failed comparison of .NOISE info in stdout!\n";
  print "Exit code = 2\n";
  exit 2;
}
else
{
  print "Passed comparison of .NOISE info in stdout\n";
  print "Exit code = 0\n";
  exit 0;
}
