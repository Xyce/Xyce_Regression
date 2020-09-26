#!/usr/bin/env perl
# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3];
$PRNOUT=$CIRFILE.".FD.prn";

# remove old output files
system("rm -f $CIRFILE\_faked* $CIRFILE.out $CIRFILE.err $CIRFILE.FD.prn");

$XYCE_ACVERIFY = $XYCE_VERIFY;
$XYCE_ACVERIFY =~ s/xyce_verify/ACComparator/;

# comparison tolerances for ACComparator.pl
$abstol=1e-6;
$reltol=1e-3;  #0.1%
$zerotol=1e-6;
$freqreltol=1e-6;

# This is the list of fields that must be in the output.
# Use of unordered maps in Xyce means they might not come out in the
# same order on different platforms.
@expectedOutputs=("Index", "FREQ",
    "Re\\(V\\(A1\\)\\)", "Im\\(V\\(A1\\)\\)", "Re\\(V\\(A2\\)\\)", "Im\\(V\\(A2\\)\\)",
    "Re\\(I\\(V1\\)\\)", "Im\\(I\\(V1\\)\\)", "Re\\(I\\(V2\\)\\)", "Im\\(I\\(V2\\)\\)");

# Now run the main netlist, which has the * characters on its print line.
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

if ( !(-f "$CIRFILE.FD.prn"))
{
    print STDERR "Missing output file $CIRFILE.FD.prn\n";
    print "Exit code = 14\n"; exit 14;
}

# pull the header line out of the file and check it for the presence of all
# required data:

open(PRNFILE,"<$PRNOUT");
$headerline=<PRNFILE>;
close(PRNFILE);

chomp($headerline);
@headerfields=split(' ',$headerline);

$retval=0;
$numMatch=0;
foreach $field (@expectedOutputs)
{
    if ( $headerline =~ /$field/ )
    {
        ++$numMatch;
    }
    else
    {
        print STDERR "Could not find field $field in primary output file.\n";
        $retval=2;
    }
}

if ($#headerfields+1 != $#expectedOutputs+1)
{
    print STDERR "Incorrect number of entries on header line in primary output file.\n";
    $retval=2;
}
elsif ($numMatch != ($#expectedOutputs + 1))
{
    print STDERR "Insufficient number of matches found on header line in primary output file.\n";
    $retval=2;
}

# only if we have all the expected outputs should we proceed.
if ($retval==0)
{
    @headerfields=split(' ',$headerline);
    # Get rid of Index and FREQ
    shift(@headerfields);
    shift(@headerfields);

    open(CIRFILE,"<$CIRFILE");
    $CIRFILE2=$CIRFILE."_faked";
    open(CIRFILE2,">$CIRFILE2");
    while(<CIRFILE>)
    {
        if (/.print/i)
        {
            print CIRFILE2 ".print ac";
            foreach $field (@headerfields)
            {
                if ( (substr($field,0,4) eq "Re(V" && substr($field,-1,1) eq ")") ||
                     (substr($field,0,4) eq "Re(I" && substr($field,-1,1) eq ")") )
                {
                  # these fields should generate a V() or I() operator on the .PRINT line
                  $outField = substr($field,3,length($field)-4);
                  print CIRFILE2 " $outField";
                }
                elsif ( (substr($field,0,4) eq "Im(V" && substr($field,-1,1) eq ")") ||
                        (substr($field,0,4) eq "Im(I" && substr($field,-1,1) eq ")") )
                {
                  # no op, to account for the expansion of V() or I() in their real
                  # and imaginary parts.
                }
                else
                {
                  print CIRFILE2 " $field";
                }
            }
            print CIRFILE2 "\n";
        }
        else
        {
            print CIRFILE2 $_;
        }
    }
    close(CIRFILE);
    close(CIRFILE2);

    # we have now created a new circuit file that should have a .print line that matches what the
    # V(*) I(*) version output
    $CMD="$XYCE $CIRFILE2 > $CIRFILE2.out 2>$CIRFILE2.err";
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

    if ( !(-f "$CIRFILE2.FD.prn"))
    {
      print STDERR "Missing output file $CIRFILE2.FD.prn\n";
      print "Exit code = 14\n"; exit 14;
    }

    # Have to use the faked cirfile here so that xyce_verify gets the right header expectations
    $CMD="$XYCE_ACVERIFY $CIRFILE2.FD.prn $CIRFILE.FD.prn $abstol $reltol $zerotol $freqreltol";
    $retcode = system($CMD);
    $retcode = $retcode >> 8;
    if ($retcode != 0){
      print STDERR "Comparator exited on file $CIRFILE.FD.prn with exit code $retcode\n";
      $retval = 2;
    }
}

print "Exit code = $retval\n";
exit $retval;
