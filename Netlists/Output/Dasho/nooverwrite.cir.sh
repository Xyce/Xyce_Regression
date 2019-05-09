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

# If Xyce does not produce the appropriate output files, then we return exit code 14.
# If Xyce succeeds, but the test fails, then we return exit code 2.
# If the shell script fails for some reason, then we return exit code 1.

# Since the shell script runs Xyce and the comparison program, it is
# responsible for capturing any error output from Xyce and the STDOUT & STDERR
# from the comparison program.  The outside script, run_xyce_regression,
# expects the STDERR output from Xyce to go into $CIRFILE.err, the STDOUT
# output from comparison to go into $CIRFILE.raw.out and the STDERR output from
# comparison to go into $CIRFILE.raw.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

@DASHOFILE;
$DASHOFILE[0]=$CIRFILE;
$DASHOFILE[1]="noover.cir";

@OUTFILE;
$OUTFILE[0]="$CIRFILE.prn";
$OUTFILE[1]="noover.cir.prn";

# Remove the previous output files, including some that are only made if the
# previous run failed.
system("rm -f $CIRFILE.prn $CIRFILE.err $CIRFILE.out nooverwriteFoo noover.cir.* $CIRFILE.prn.*");

# run Xyce
foreach $idx (0 .. 1)
{
  $CMD="$XYCE -o $DASHOFILE[$idx] $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
  $retval=system($CMD);

  if ($retval != 0)
  {
    if ($retval & 127)
    {
      print "Exit code = 13\n"; 
      printf STDERR "Xyce crashed with signal %d on file %s\n with -o of $DASHOFILE[$idx]",($retval&127),$CIRFILE; 
      exit 13;
    }
    else
    {
      print "Exit code = 10\n"; 
      printf STDERR "Xyce exited with exit code %d on %s\n with -o of $DASHOFILE[$idx]",$retval>>8,$CIRFILE; 
      exit 10;
    }
  }

  # check for output files
  $xyceexit=0;
  if ( -f "nooverwriteFoo") {
    print STDERR "Extra output file tranFoo\n";
    $xyceexit=2;
  }

  if ( !(-f "$OUTFILE[$idx]") ){
    print STDERR "Missing -o output file, $OUTFILE[$idx]\n";
    $xyceexit=14;
  }

  if ($xyceexit!=0) {print "Exit code = $xyceexit\n"; exit $xyceexit;}
}

# Now verify the output file, which is nooverwrite.cir.prn in this case. 
# Use file_compare.pl since I'm also testing print line concatenation 
$retcode=0;

$fc=$XYCE_VERIFY;
$fc =~ s/xyce_verify/file_compare/;
$abstol=1e-4;
$reltol=1e-3;
$zerotol=1e-6;

foreach $idx (0 .. 1)
{
  $CMD="$fc $OUTFILE[$idx] $GOLDPRN $abstol $reltol $zerotol > $OUTFILE[$idx].out 2> $OUTFILE[$idx].err";
  if (system($CMD) != 0) {
      print STDERR "Verification failed on file $OUTFILE[$idx], see $OUTFILE[$idx].prn.err\n";
      $retcode = 2;
  }
}

print "Exit code = $retcode\n"; exit $retcode;


