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
# output from comparison to go into $CIRFILE.dat.out and the STDERR output from
# comparison to go into $CIRFILE.dat.err.

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDDAT=$ARGV[4];

$GOLDDAT =~ s/\.prn$//; # remove the .prn at the end.

$GOLDDAT =~ s/tecplot/prn/; # use the prn gold standard.

$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

$TRANSLATE="python convertXyceFormat.py -s -o";

#comparison tolerances for ACComparator.pl
$abstol=1e-6;
$reltol=1e-4;
$zerotol=1e-14;
$freqreltol=1e-7;

#remove previous output files
system("rm -f $CIRFILE.*.dat $CIRFILE.*.out. $CIRFILE.*.err $CIRFILE.out $CIRFILE.err");

#run Xyce
$CMD="$XYCE $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
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

# check if the 3 tecplot output files exist.
if ( !(-f "$CIRFILE.HB.TD.dat")) {
    print STDERR "Missing output file $CIRFILE.HB.TD.dat\n";
    $xyceexit=14;
}
if ( !(-f "$CIRFILE.HB.FD.dat")) {
    print STDERR "Missing output file $CIRFILE.HB.FD.dat\n";
    $xyceexit=14;
}
if ( !(-f "$CIRFILE.hb_ic.dat")) {
    print STDERR "Missing output file $CIRFILE.hb_ic.dat\n";
    $xyceexit=14;
}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

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

$retcode = 0;

# Tests for .HB.TD.dat file
$retcode = testFileBasic("$CIRFILE.HB.TD.dat");

# convert and compare the *HB.TD.dat file.
$result = system( "$TRANSLATE $CIRFILE.HB.TD.dat");
if ( $result != 0 )
{
  print "Failed to translate TECPLOT to STD\n";
  $retcode = 2;
}
else
{
  $CMD="$XYCE_VERIFY $CIRFILE $GOLDDAT.HB.TD.prn test_$CIRFILE.HB.TD.dat > $CIRFILE.HB.TD.dat.out 2> $CIRFILE.HB.TD.dat.err";
  if (system("$CMD") != 0) {
       print STDERR "Verification failed on file $CIRFILE.HB.TD.dat, see $CIRFILE.HB.TD.dat.err\n";
       $retcode = 2;
  }
}

# Tests for .HB.FD.dat file
$retcode = testFileBasic("$CIRFILE.HB.FD.dat");

# convert and compare the *HB.FD.dat file.
$result = system( "$TRANSLATE $CIRFILE.HB.FD.dat");
if ( $result != 0 )
{
  print "Failed to translate TECPLOT to STD\n";
  $retcode = 2;
}
else
{
  $CMD="$XYCE_ACVERIFY --skipfooter $GOLDDAT.HB.FD.prn test_$CIRFILE.HB.FD.dat $abstol $reltol $zerotol $freqreltol > $CIRFILE.HB.FD.dat.out 2> $CIRFILE.HB.FD.dat.err";
  if (system($CMD) != 0) {
       print STDERR "Verification failed on file $CIRFILE.HB.FD.dat vs $GOLDDAT.HB.FD.prn, see $CIRFILE.HB.FD.dat.err\n";
       $retcode = 2;
  }
}

# Tests for .hb_ic.dat file
$retcode = testFileBasic("$CIRFILE.hb_ic.dat");

# convert and compare the *hb_ic.dat file.
$result = system( "$TRANSLATE $CIRFILE.hb_ic.dat"); 
if ( $result != 0 )
{
  print "Failed to translate TECPLOT to STD\n";
  $retcode = 2;
}
else
{
  $CMD="$XYCE_VERIFY $CIRFILE $GOLDDAT.hb_ic.prn test_$CIRFILE.hb_ic.dat > $CIRFILE.hb_ic.dat.out 2> $CIRFILE.hb_ic.dat.err";
  if (system($CMD) != 0) {
      print STDERR "Verification failed on file $CIRFILE.hb_ic.dat, see $CIRFILE.hb_ic.dat.err\n";
      $retcode = 2;
  }
}

print "Exit code = $retcode\n"; exit $retcode;


########## sub declarations

sub testFileBasic {

  my ($filename) = @_;

  my $retcode = 0;

  # check the number of TITLE outputs
  $titlecount = `grep -ic title $filename 2>/dev/null`;
  if ($titlecount =~ 1)
  {
    printf "Tecplot file %s contained correct number(%d) of titles.\n", $filename, $titlecount;
  }
  else
  {
    printf "Tecplot file %s contained wrong number(%d) of titles.\n", $filename, $titlecount;
    my $retcode = 2;
  }

  # check the number of ZONE outputs
  $zonecount = `grep -ic zone $filename 2>/dev/null`;
  if ($zonecount =~ 3)
  {
    printf "Tecplot file %s contained correct number(%d) of zones.\n", $filename,$zonecount;
  }
  else
  {
    printf "Tecplot file %s contained wrong number(%d) of zones.\n", $filename,$zonecount;
    my $retcode = 2;
  }

  # check the number of AUXDATA outputs
  $auxdatacount = `grep -iv datasetauxdata $filename | grep -ic auxdata 2>/dev/null`;
  if ($auxdatacount =~ 3)
  {
    printf "Tecplot file %s contained correct number(%d) of auxdata's.\n", $filename,$auxdatacount;
  }
  else
  {
    printf "Tecplot file %s contained wrong number(%d) of auxdata's.\n", $filename,$auxdatacount;
    my $retcode = 2;
  }

  # check the number of DATASETAUXDATA outputs
  $datasetauxdatacount = `grep -ic datasetauxdata $filename 2>/dev/null`;
  if ($datasetauxdatacount =~ 2)
  {
    printf "Tecplot file %s contained correct number(%d) of datasetauxdata's.\n", $filename,$datasetauxdatacount;
  }
  else
  {
    printf "Tecplot file %s contained wrong number(%d) of datasetauxdata's.\n", $filename,$datasetauxdatacount;
    my $retcode = 2;
  }

  # check the number of "End of Xyce(TM) Parameter Sweep" outputs
  $xyceEndCount = `grep -ic "End of Xyce(TM) Parameter Sweep" $filename 2>/dev/null`;
  if ($xyceEndCount =~ 1)
  {
    printf "Tecplot file %s contained correct number(%d) of \"End of Xyce(TM) Parameter Sweep\" statements.\n", $filename,$xyceEndCount;
  }
  else
  {
    printf "Tecplot file %s contained wrong number(%d) of \"End of Xyce(TM) Parameter Sweep\" statements.\n", $filename,$xyceEndCount;
    my $retcode = 2;
  }

  return $retcode;

}

