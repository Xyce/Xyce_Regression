#!/usr/bin/env perl

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script  (This is NEVER used and can be ignored)
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

# This test case runs a simple biased transistor and computes the
# sensitivities with respect to a few model variables.
#
# A second netlist, in which the sensitivities are generated by finite
# differencing between perturbed copies of the circuit, is also run.  The
# analytic sensitivities from the first netlist are compared to the
# sensitivities from the second.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3]; 

$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

$CIR1 = $CIRFILE;
$CIR2 = $CIRFILE;
$CIR2 =~ s/.cir/_fd.cir/;

`rm -f $CIR1*prn* $CIR1*.out $CIR2*prn* $CIR2*.out $CIR1.err $CIR2.err $CIR1.prn.err $CIR2*prn.err`;
$CMD="$XYCE $CIR1 > $CIR1.out 2> $CIR1.err";
if (system($CMD) != 0)
{
    print "Xyce EXITED WITH ERROR! on $CIR1\n";
    $xyceexit=1;
}
else
{
    if (-z "$CIR1.err" ) {`rm -f $CIR1.err`;}
}

if (defined ($xyceexit)) {print "Exit code = 10\n"; exit 10;}

if ( ! -f "$CIR1.FD.SENS.prn")
{
    print STDERR "$CIR1.FD.SENS.prn not created\n";
    print "Exit code = 14\n";
    exit 14;
}

#Run the Finite Difference (FD) circuit
$CMD="$XYCE $CIR2 > $CIR2.out 2> $CIR2.err";
if (system($CMD) != 0)
{
    print "Xyce EXITED WITH ERROR! on $CIR2\n";
    $xyceexit=1;
}
else
{
    if (-z "$CIR2.err" ) {`rm -f $CIR2.err`;}
}

if (defined ($xyceexit)) {print "Exit code = 10\n"; exit 10;}

if ( ! -f "$CIR2.FD.prn")
{
    print STDERR "$CIR2.FD.prn not created\n";
    print "Exit code = 14\n";
    exit 14;
}

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl
if ($XYCE_VERIFY =~ m/valgrind_check/)
{
  print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
  if (system("$XYCE_VERIFY $CIRFILE unusedarg > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
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

$retcode=0;

# The FD circuit .prn file has very, very different headers than the analytic 
# .FD.SENS.prn, which will cause xyce_verify to complain vigorously and exit
# due to the header mismatch if used directly.  So we will simply copy the
# .FD.SENS.prn header of the analytic file into the FD, and use that
# modified version for comparison.  The header contains slashes, so we
# have to use "-" as the delimiter for sed.  THIS IS VERY SPECIFIC TO THIS
# NETLIST, though, because "-" is a valid character in general headers, and
# if this script is copied and used for some other test case, one must modify
# the sed delimiter to use a character that is certain not to appear in the
# header!

$HEADER1=`head -1 $CIR1.FD.SENS.prn`;
chomp $HEADER1;
$SEDCMD="sed '1 s-^.*\$-".$HEADER1."-g'";
`$SEDCMD $CIR2.FD.prn > $CIR2.FD.SENS.prn`;


$SEDCMD2="sed 's/ Sensitivity / /g'";
`$SEDCMD2 $CIR1.FD.SENS.prn > tmp_param`;
$CPCMD="mv tmp_param $CIR1.FD.SENS.prn";
`$CPCMD`;

if (-f "$CIR2.FD.SENS.prn")
{
  #comparison tolerances for ACComparator.pl
  $abstol=4.0e4; # probably overkill
  $reltol=3e-2;  
  $zerotol=1e-8;
  $freqreltol=1e-6;

  $CMD="$XYCE_ACVERIFY  $CIR2.FD.SENS.prn $CIR1.FD.SENS.prn $abstol $reltol $zerotol $freqreltol";
  $retval=system($CMD);
  $retval = $retval >> 8;
  if ($retval != 0)
  {
    print STDERR "Comparator exited with exit code $retval on file $CIR1.FD.SENS.prn\n";
    $retcode = 2;
  }
}
else
{
  print STDERR "Missing output file: $CIRFILE.FD.SENS.prn\n";
  $retcode = 14;
}

print "Exit code = $retcode\n"; exit $retcode;


