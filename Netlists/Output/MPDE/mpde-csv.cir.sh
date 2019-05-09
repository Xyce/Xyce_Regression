#!/usr/bin/env perl

use File::Basename;
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
#$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$CIR1="mpde-csv.cir";
$CIR2="mpde-csv-fallback.cir";

$GOLDDIR = dirname($GOLDPRN);
$GOLD1 = "$GOLDDIR/$CIR1";
$GOLD2 = "$GOLDDIR/$CIR2";

# remove previous output files
system("rm -f $CIR1.prn $CIR1.MPDE.* $CIR1.mpde_ic.* $CIR1.startup.* $CIR1.out $CIR1.err");
system("rm -f $CIR2.prn $CIR2.MPDE.* $CIR2.mpde_ic.* $CIR2.startup.* $CIR2.out $CIR2.err");

# run Xyce on both netlists
$CMD="$XYCE $CIR1 > $CIR1.out 2>$CIR1.err";
$retval=system($CMD);

if ($retval != 0)
{
  if ($retval & 127)
  {
    print "Exit code = 13\n"; 
    printf STDERR "Xyce crashed with signal %d on file %s\n",($retval&127),$CIR1; 
    exit 13;
  }
  else
  {
    print "Exit code = 10\n"; 
    printf STDERR "Xyce exited with exit code %d on %s\n",$retval>>8,$CIR1; 
    exit 10;
  }
}

$CMD="$XYCE $CIR2 > $CIR2.out 2>$CIR2.err";
$retval=system($CMD);

if ($retval != 0)
{
  if ($retval & 127)
  {
    print "Exit code = 13\n"; 
    printf STDERR "Xyce crashed with signal %d on file %s\n",($retval&127),$CIR2; 
    exit 13;
  }
  else
  {
    print "Exit code = 10\n"; 
    printf STDERR "Xyce exited with exit code %d on %s\n",$retval>>8,$CIR2; 
    exit 10;
  }
}

# check for output files from both netlists
if ( !(-f "$CIR1.prn")) {
    print STDERR "Missing output file $CIR1.prn\n";
    $xyceexit=14;
}
if ( !(-f "$CIR1.MPDE.csv")) {
    print STDERR "Missing output file $CIR1.MPDE.csv\n";
    $xyceexit=14;
}
if ( !(-f "$CIR1.mpde_ic.csv")) {
    print STDERR "Missing output file $CIR1.mpde_ic.csv\n";
    $xyceexit=14;
}
if ( !(-f "$CIR1.startup.csv")) {
    print STDERR "Missing output file $CIR1.startup.csv\n";
    $xyceexit=14;
}

# netlist 2
if ( !(-f "$CIR2.prn")) {
    print STDERR "Missing output file $CIR2.prn\n";
    $xyceexit=14;
}
if ( !(-f "$CIR2.MPDE.csv")) {
    print STDERR "Missing output file $CIR2.MPDE.csv\n";
    $xyceexit=14;
}
if ( !(-f "$CIR2.mpde_ic.csv")) {
    print STDERR "Missing output file $CIR2.mpde_ic.csv\n";
    $xyceexit=14;
}
if ( !(-f "$CIR2.startup.csv")) {
    print STDERR "Missing output file $CIR2.startup.csv\n";
    $xyceexit=14;
}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

$retcode = 0;
# check for absence of simulation footer text (for CSV format)
# Output from Netlist 1
$xyceEndCount = `grep -ic "End of Xyce(TM) Simulation" $CIR1.MPDE.csv 2>/dev/null`;
if ($xyceEndCount == 0)
{
  printf "Output file $CIR1.MPDE.csv contained correct number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
}
else
{
  printf "Output file $CIR1.MPDE.csv contained wrong number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
  $retcode = 2;
}

$xyceEndCount = `grep -ic "End of Xyce(TM) Simulation" $CIR1.mpde_ic.csv 2>/dev/null`;
if ($xyceEndCount == 0)
{
  printf "Output file $CIR1.mpde_ic.csv contained correct number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
}
else
{
  printf "Output file $CIR1.mpde_ic.csv contained wrong number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
  $retcode = 2;
}

$xyceEndCount = `grep -ic "End of Xyce(TM) Simulation" $CIR1.startup.csv 2>/dev/null`;
if ($xyceEndCount == 0)
{
  printf "Output file $CIR1.startup.csv contained correct number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
}
else
{
  printf "Output file $CIR1.startup.csv contained wrong number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
  $retcode = 2;
}

# output for Netlist 2
$xyceEndCount = `grep -ic "End of Xyce(TM) Simulation" $CIR2.MPDE.csv 2>/dev/null`;
if ($xyceEndCount == 0)
{
  printf "Output file $CIR2.MPDE.csv contained correct number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
}
else
{
  printf "Output file $CIR2.MPDE.csv contained wrong number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
  $retcode = 2;
}

$xyceEndCount = `grep -ic "End of Xyce(TM) Simulation" $CIR2.mpde_ic.csv 2>/dev/null`;
if ($xyceEndCount == 0)
{
  printf "Output file $CIR2.mpde_ic.csv contained correct number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
}
else
{
  printf "Output file $CIR2.mpde_ic.csv contained wrong number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
  $retcode = 2;
}

$xyceEndCount = `grep -ic "End of Xyce(TM) Simulation" $CIR2.startup.csv 2>/dev/null`;
if ($xyceEndCount == 0)
{
  printf "Output file $CIR2.startup.csv contained correct number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
}
else
{
  printf "Output file $CIR2.startup.csv contained wrong number(%d) of \"End of Xyce(TM) Simulation\" statements.\n",$xyceEndCount;
  $retcode = 2;
}

# check contents of MPDE-specific output files for both netlists.
#print "Checking contents of output files\n";

#$CMD="$fc $CIR1.MPDE.csv $GOLD1.MPDE.csv $abstol $reltol $zerotol > $CIR1.MPDE.csv.out 2> $CIR1.MPDE.csv.err";
#if (system("$CMD") != 0) {
#    print STDERR "Verification failed on file $CIR1.MPDE.csv, see $CIR1.MPDE.csv.err\n";
#    $retcode = 2;
#}

#$CMD="$XYCE_VERIFY $CIR1 $GOLD1.mpde_ic.csv $CIR1.mpde_ic.csv > $CIR1.mpde_ic.csv.out 2> $CIR1.mpde_ic.csv.err";
#if (system("$CMD") != 0) {
#    print STDERR "Verification failed on file $CIR1.mpde_ic.csv, see $CIR1.mpde_ic.csv.err\n";
#    $retcode = 2;
#}

#$CMD="$XYCE_VERIFY $CIR1 $GOLD1.startup.csv $CIR1.startup.csv > $CIR1.startup.csv.out 2> $CIR1.startup.csv.err";
#if (system("$CMD") != 0) {
#    print STDERR "Verification failed on file $CIR1.startup.csv, see $CIR1.startup.csv.err\n";
#    $retcode = 2;
#}

# netlist 2

#$CMD="$fc $CIR2.MPDE.csv $GOLD2.MPDE.csv $abstol $reltol $zerotol > $CIR2.MPDE.csv.out 2> $CIR2.MPDE.csv.err";
#if (system("$CMD") != 0) {
#    print STDERR "Verification failed on file $CIR2.MPDE.csv, see $CIR2.MPDE.csv.err\n";
#    $retcode = 2;
#}

#$CMD="$XYCE_VERIFY $CIR2 $GOLD2.mpde_ic.csv $CIR2.mpde_ic.csv > $CIR2.mpde_ic.csv.out 2> $CIR2.mpde_ic.csv.err";
#if (system("$CMD") != 0) {
#    print STDERR "Verification failed on file $CIR2.mpde_ic.csv, see $CIR2.mpde_ic.csv.err\n";
#    $retcode = 2;
#}

#$CMD="$XYCE_VERIFY $CIR2 $GOLD2.startup.csv $CIR2.startup.csv > $CIR2.startup.csv.out 2> $CIR2.startup.csv.err";
#if (system("$CMD") != 0) {
#    print STDERR "Verification failed on file $CIR2.startup.csv, see $CIR2.startup.csv.err\n";
#    $retcode = 2;
#}

print "Exit code = $retcode\n"; exit $retcode;
