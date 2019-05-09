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

$DASHRFILE="dashrOutput";
$DASHOFILE="dashoOutput";
$GOLDPRN =~ s/\.prn$//; # remove the .prn at the end.

# Remove the previous output files, including some that are only made if the
# previous run failed.
system("rm -f $CIRFILE.prn $CIRFILE.err $CIRFILE.out $CIRFILE.raw $CIRFILE.raw.*");
system("rm -f $DASHOFILE $DASHRFILE $DASHRFILE.*" );

# run Xyce with both the -r and -o command line options.  -r takes precedence.
$CMD="$XYCE -r $DASHRFILE -o $DASHOFILE -a $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
$retval=system($CMD);

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

# check for output files  
$xyceexit=0;
if ( -f "$CIRFILE.prn" ) {
  print STDERR "Extra output file $CIRFILE.prn\n";
  $xyceexit=2;
}

if ( -f "$DASHOFILE") {
  print STDERR "Extra output file $DASHOFILE\n";
  $xyceexit=2;
}

if ( !(-f "$DASHRFILE") ){
  print STDERR "Missing -o output file $DASHRFILE\n";
  $xyceexit=14;
}

if ($xyceexit!=0) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

# Now verify the output raw file, which is in ASCII format.
$retcode = 0;

if (system("grep -v 'Date:' $DASHRFILE > $DASHRFILE.filtered 2>$DASHRFILE.filtered.out") != 0)
{
  print STDERR "Date line not found in file $DASHRFILE, see $DASHRFILE.filtered.out\n";
  $retcode = 2;
}

if (system("grep -v 'Date:' $GOLDPRN.raw > $CIRFILE.raw.filtered 2>$CIRFILE.raw.filtered.out") != 0)
{
  print STDERR "Date line not found in file $DASHRFILE, see $CIRFILE.raw.filtered.out\n";
  $retcode = 2;
}

$CMD="diff -bw $CIRFILE.raw.filtered $DASHRFILE.filtered > $DASHRFILE.out";
if (system($CMD) != 0) {
    print STDERR "Verification failed on file $DASHRFILE, see $DASHRFILE.out\n";
    $retcode = 2;
}

print "Exit code = $retcode\n"; exit $retcode;


