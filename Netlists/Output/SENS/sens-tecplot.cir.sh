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
$GOLDDAT =~ s/tecplot/prn/; # remove the .prn at the end.

$TRANSLATE="python convertXyceFormat.py -s -o";

system("rm -f $CIRFILE.out $CIRFILE.err $CIRFILE.dat $CIRFILE.SENS.dat $CIRFILE.err $CIRFILE.SENS.err");

$CMD="$XYCE $CIRFILE > $CIRFILE.out 2>$CIRFILE.err";
if (system($CMD) != 0) {
    `echo "Xyce EXITED WITH ERROR! on $CIRFILE" >> $CIRFILE.err`;
    $xyceexit=1;
}

if (defined ($xyceexit)) {print "Exit code = 10\n"; exit 10;}

if ( !(-f "$CIRFILE.dat")) {
    print STDERR "Missing output file $CIRFILE.dat\n";
    $xyceexit=14;
}

if ( !(-f "$CIRFILE.SENS.dat")) {
    print STDERR "Missing output file $CIRFILE.SENS.dat\n";
    $xyceexit=14;
}

if (defined ($xyceexit)) {print "Exit code = $xyceexit\n"; exit $xyceexit;}

$retcode = 0;

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl
if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $CIRFILE $GOLDDAT $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
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

# check the number of TITLE outputs
$titlecount = `grep -ic title $CIRFILE.dat 2>/dev/null`;
if ($titlecount =~ 1)
{
  printf "Tecplot file contained correct number(%d) of titles.\n", $titlecount;
}
else
{
  printf "Tecplot file contained wrong number(%d) of titles.\n", $titlecount;
  $retcode = 2;
}

$titlecount = `grep -ic title $CIRFILE.SENS.dat 2>/dev/null`;
if ($titlecount =~ 1)
{
  printf "Tecplot file contained correct number(%d) of titles.\n", $titlecount;
}
else
{
  printf "Tecplot file contained wrong number(%d) of titles.\n", $titlecount;
  $retcode = 2;
}

# check the number of ZONE outputs
$zonecount = `grep -ic zone $CIRFILE.dat 2>/dev/null`;
if ($zonecount =~ 1)
{
  printf "Tecplot file $CIRFILE.dat contained correct number(%d) of zones.\n",$zonecount;
}
else
{
  printf "Tecplot file $CIRFILE.dat contained wrong number(%d) of zones.\n",$zonecount;
  $retcode = 2;
}

$zonecount = `grep -ic zone $CIRFILE.SENS.dat 2>/dev/null`;
if ($zonecount =~ 1)
{
  printf "Tecplot file $CIRFILE.SENS.dat contained correct number(%d) of zones.\n",$zonecount;
}
else
{
  printf "Tecplot file $CIRFILE.SENS.dat contained wrong number(%d) of zones.\n",$zonecount;
  $retcode = 2;
}

# check the number of DATASETAUXDATA outputs
$datasetauxdatacount = `grep -ic datasetauxdata $CIRFILE.dat 2>/dev/null`;
if ($datasetauxdatacount =~ 2)
{
  printf "Tecplot file $CIRFILE.dat contained correct number(%d) of datasetauxdata's.\n",$datasetauxdatacount;
}
else
{
  printf "Tecplot file $CIRFILE.dat contained wrong number(%d) of datasetauxdata's.\n",$datasetauxdatacount;
  $retcode = 2;
}

$datasetauxdatacount = `grep -ic datasetauxdata $CIRFILE.SENS.dat 2>/dev/null`;
if ($datasetauxdatacount =~ 2)
{
  printf "Tecplot file $CIRFILE.SENS.dat contained correct number(%d) of datasetauxdata's.\n",$datasetauxdatacount;
}
else
{
  printf "Tecplot file $CIRFILE.SENS.dat contained wrong number(%d) of datasetauxdata's.\n",$datasetauxdatacount;
  $retcode = 2;
}


#VARIABLES = " V(2)"
#" I(V1)"
#" {I(V1)}"
#" d{I(V1)}/d(DA:RS)_Adj"
#" d{I(V1)}/d(DA:IS)_Adj"

# check the number of VARIABLES outputs
$variablescount = `grep -ic variables $CIRFILE.dat 2>/dev/null`;
if ($variablescount =~ 1)
{
  printf "Tecplot $CIRFILE.dat file contained correct number(%d) of variables strings.\n",$variablescount;
}
else
{
  printf "Tecplot $CIRFILE.dat file contained wrong number(%d) of variables strings.\n",$variablescount;
  $retcode = 2;
}

$variablescount = `grep -ic variables $CIRFILE.SENS.dat 2>/dev/null`;
if ($variablescount =~ 1)
{
  printf "Tecplot $CIRFILE.SENS.dat file contained correct number(%d) of variables strings.\n",$variablescount;
}
else
{
  printf "Tecplot $CIRFILE.SENS.dat file contained wrong number(%d) of variables strings.\n",$variablescount;
  $retcode = 2;
}

$footercount = `grep -ic "End of Xyce(TM) Sensitivity Simulation" $CIRFILE.SENS.dat 2>/dev/null`;
if ($footercount =~ 1)
{
  print "Tecplot $CIRFILE.SENS.dat file contained correct simulation footer\n";
}
else
{
  print "Tecplot $CIRFILE.SENS.dat file contained wrong simulation footer.\n";
  $retcode = 2;
}


# convert and compare the dat file.
$result = system( "$TRANSLATE $CIRFILE.dat");
if ( $result != 0 )
{
  print "Failed to translate TECPLOT to STD\n";
  $retcode = 2;
}
else
{
 $CMD="$XYCE_VERIFY $CIRFILE test_$CIRFILE.dat $GOLDDAT.prn > $CIRFILE.dat.out 2> $CIRFILE.dat.err";
 if (system("$CMD") != 0) {
     print STDERR "Verification failed on file $CIRFILE.dat, see $CIRFILE.dat.err\n";
     $retcode = 2;
 }
}

# convert and compare the SENS.dat file.
$result = system( "$TRANSLATE $CIRFILE.SENS.dat");
if ( $result != 0 )
{
  print "Failed to translate TECPLOT to STD\n";
  $retcode = 2;
}
else
{
 $CMD="$XYCE_VERIFY --printline=sens $CIRFILE test_$CIRFILE.SENS.dat $GOLDDAT.SENS.prn > $CIRFILE.SENS.dat.out 2> $CIRFILE.SENS.dat.err";
 if (system("$CMD") != 0) {
     print STDERR "Verification failed on file $CIRFILE.SENS.dat, see $CIRFILE.SENS.dat.err\n";
     $retcode = 2;
 }
}

print "Exit code = $retcode\n"; exit $retcode;
