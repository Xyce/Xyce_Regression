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

&GetOptions( "verbose!" => \$verbose );
$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
#$XYCE_COMPARE=$ARGV[2];
#$CIRFILE=$ARGV[3];
#$GOLDPRN=$ARGV[4];

if (defined($verbose)) { $Tools->setVerbose(1); }

$Tools->setVerbose(1);

sub verbosePrint { $Tools->verbosePrint(@_); }

$CIR1="vbicNandStep.cir";

verbosePrint "Running $CIR1...\n";
$retval=$Tools->wrapXyce($XYCE,$CIR1);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }

# Now produce the gold standards
@CIRLIST = ( "vbicNand0.cir",
             "vbicNand1.cir");

@STEPRES1 = (9.0e+5, 1e6);# rta1 value

verbosePrint "Generating vbicNandStep.cir.prn.gs\n";
open(GS,">$CIR1.prn.gs");
$first_run=1;
foreach $CIR (@CIRLIST)
{
  verbosePrint "Running $CIR...\n";
  $retval=$Tools->wrapXyce($XYCE,$CIR);
  if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
  if (not -s "$CIR.prn") { print "Exit code = 14\n"; exit 14; }
  open(CIR,"$CIR.prn") or die "ERROR:  Cannot open $CIR.prn\n";
  while ($line = <CIR>)
  {
    if ($line =~ "Index" && $first_run==0) { next; }
    if ($line =~ "Xyce") { next; }
    print GS "$line";
    $first_run=0;
  }
  close(CIR);
}
print GS   "End of Xyce(TM) Parameter Sweep\n";
close(GS);

verbosePrint "Generating vbicNandStep.cir.res.gs\n";
$GOLDRES = "vbicNandStep.cir.res.gs";
open(GRES,">$GOLDRES");
print GRES "STEP           XN1:RTA1:R\n";
for ($i=0 ; $i<= $#STEPRES1 ; $i++)
{
  printf GRES ("%g        %g\n",$i,$STEPRES1[$i]);
}
print GRES "End of Xyce(TM) Parameter Sweep\n";
close(GRES);

verbosePrint "Comparing vbicNandStep.cir...\n";
$CMD="$XYCE_VERIFY --goodres=$GOLDRES --testres=vbicNandStep.cir.res vbicNandStep.cir vbicNandStep.cir.prn.gs vbicNandStep.cir.prn > vbicNandStep.cir.prn.out 2> vbicNandStep.cir.prn.err";
if (system("$CMD") != 0) { $failure = 1; }


if ($failure)
{
  verbosePrint "Test Failed!\n";
  print "Exit code = 2\n"; exit 2;
}
else
{
  verbosePrint "Test Passed!\n";
  print "Exit code = 0\n"; exit 0;
}

print "Exit code = 1\n"; exit 1;

