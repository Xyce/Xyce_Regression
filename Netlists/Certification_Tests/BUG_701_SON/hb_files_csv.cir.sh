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
# output from comparison to go into $CIRFILE.raw.out and the STDERR output from
# comparison to go into $CIRFILE.raw.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
#$CIRFILE=$ARGV[3];
$GOLDCSV=$ARGV[4];

$GOLDCSV =~ s/\.prn$//; # remove the .prn at the end.
$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;
$fc = $XYCE_VERIFY;
$fc =~ s/xyce_verify/file_compare/;

# comparison tolerances for ACComparator.pl and file_compare.pl
$abstol=1e-6;
$reltol=1e-3;  #0.1%
$zerotol=1e-8;
$freqreltol=1e-6;

# these files have various .PRINT AC and .PRINT AC_IC lines in them
@CIR;
@FD_OUT;
@TD_OUT;
@IC_OUT;
@ST_OUT;
$CIR[0]="hb_files_csv.cir";
$FD_OUT[0]="hb_bleem_fd_csv";
$TD_OUT[0]="hb_bleem_td_csv";
$IC_OUT[0]="hb_bleem_ic_csv";
$ST_OUT[0]="hb_bleem_startup_csv";

$CIR[1]="hb_files_fallback_csv.cir";
$FD_OUT[1]="hb_foo_csv.HB.FD.csv";
$TD_OUT[1]="hb_foo_csv.HB.TD.csv";
$IC_OUT[1]="hb_foo_csv.hb_ic.csv";
$ST_OUT[1]="hb_foo_csv.startup.csv";

# run the netlists
foreach $idx (0 .. 1)
{
  # Remove the previous output files.  $CIRFILE.prn file should not be made, but
  # remove it if it was made during a previous run.
  system("rm -f $CIR[$idx].err $CIR[$idx].out $FD_OUT[$idx] $TD_OUT[$idx] $FD_OUT[$idx].* $TD_OUT[$idx].*");
  system("rm -f $IC_OUT[$idx] $ST_OUT[$idx] $IC_OUT[$idx].* $ST_OUT[$idx].*");

  # run Xyce
  $CMD="$XYCE $CIR[$idx] > $CIR[$idx].out 2>$CIR[$idx].err";
  $retval=system($CMD);

  if ($retval != 0)
  {
    if ($retval & 127)
    {
      print "Exit code = 13\n"; 
      printf STDERR "Xyce crashed with signal %d on file %s\n",($retval&127),$CIR[$idx]; 
      exit 13;
    }
    else
    {
      print "Exit code = 10\n"; 
      printf STDERR "Xyce exited with exit code %d on %s\n",$retval>>8,$CIR[$idx]; 
    exit 10;
    }

  }
  
  $xyceexit=0;
  if ( !(-f "$FD_OUT[$idx]")) {
    print STDERR "Missing output file $FD_OUT[$idx]\n";
    $xyceexit=14;
  }

  if ( !(-f "$TD_OUT[$idx]")) {
    print STDERR "Missing output file $TD_OUT[$idx]\n";
    $xyceexit=14;
  }

  if ( !(-f "$IC_OUT[$idx]")) {
    print STDERR "Missing output file $IC_OUT[$idx]\n";
    $xyceexit=14;
  }

  if ( !(-f "$ST_OUT[$idx]")) {
    print STDERR "Missing output file $ST_OUT[$idx]\n";
    $xyceexit=14;
  }

  if ( ($idx== 0) && (-f "hb_bar")) {
    print STDERR "Extra output file hb_bar made\n";
    $xyceexit=14;
  }

  if ($xyceexit!=0) {print "Exit code = $xyceexit\n"; exit $xyceexit;}
}


$retcode=0;
foreach $idx (0 .. 1)
{
  $CMD="$XYCE_VERIFY $CIR[$idx] $GOLDCSV.TD.csv $TD_OUT[$idx] > $TD_OUT[$idx].out 2> $TD_OUT[$idx].err";
  if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $TD_OUT[$idx], see $TD_OUT[$idx].err\n";
    $retcode = 2;
  }

  $CMD="$XYCE_ACVERIFY --gsformat=xycecsv $GOLDCSV.FD.csv $FD_OUT[$idx] $abstol $reltol $zerotol $freqreltol > $FD_OUT[$idx].out 2> $FD_OUT[$idx].err";
  $retval = system($CMD);
  $retval = $retval >> 8;
  if ($retval != 0) 
  { 
    print STDERR "Verification failed on file $FD_OUT[$idx], see $FD_OUT[$idx].err\n";
    $retcode = 2; 
  }

  $CMD="$XYCE_VERIFY $CIR[$idx] $GOLDCSV.hb_ic.csv $IC_OUT[$idx] > $IC_OUT[$idx].out 2> $IC_OUT[$idx].err";
  if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $IC_OUT[$idx], see $IC_OUT[$idx].err\n";
    $retcode = 2;
  }

  $CMD="$XYCE_VERIFY $CIR[$idx] $GOLDCSV.startup.csv $ST_OUT[$idx] > $ST_OUT[$idx].out 2> $ST_OUT[$idx].err";
  if (system("$CMD") != 0) {
    print STDERR "Verification failed on file $ST_OUT[$idx], see $ST_OUT[$idx].err\n";
    $retcode = 2;
  }
}

print "Exit code = $retcode\n"; exit $retcode;


