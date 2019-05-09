#!/usr/bin/env perl
# The input arguments to this script are: 
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script 
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

# This test is intended to verify that V(*) I(*) on a .print line
# works properly when there are voltage sources inside subcircuits.
# Prior to the fix of bug 715, this would lead to Xyce exiting
# with a netlist error.

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$CIRFILE=$ARGV[3];
$PRNOUT=$CIRFILE.".prn";

# This is the list of fields that must be in the output.
# Use of unordered maps in Xyce means they might not come out in the 
# same order on different platforms.
@expectedOutputs=("Index", "TIME", "V\(X1:2)", "V\(X1:1)", "V\(4)", "V\(3)", "V\(2)", "V\(1)",
                  "I\(X1:X2:V1)", "I\(X1:V1)", "I\(E2)", "I\(V1)", "I\(X1:X2:L1)");

# Now run the main netlist, which has the V(*) I(*) print line in it.
$retval = -1;
$retval=$Tools->wrapXyce($XYCE,$CIRFILE);
if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
if (not -s "$PRNOUT" ) { print "Exit code = 14\n"; exit 14; }

# pull the header line out of the file and check it for the presence of all
# required data:

open(PRNFILE,"<$PRNOUT");
$headerline=<PRNFILE>;
close(PRNFILE);

chomp($headerline);

$retval=0;
foreach $field (@expectedOutputs)
{
    if (! $headerline =~ /$field/ )
    {
        print STDERR "Could not find field $field in primary output file.\n";
        $retval=2;
    }
}

# only if we have all the expected outputs should we proceed.
if ($retval==0)
{
    @headerfields=split(' ',$headerline);
    # Get rid of Index and Time
    shift(@headerfields);
    shift(@headerfields);

    open(CIRFILE,"<$CIRFILE");
    $CIRFILE2=$CIRFILE."_faked";
    open(CIRFILE2,">$CIRFILE2");
    while(<CIRFILE>)
    {
        if (/.print/i)
        {
            print CIRFILE2 ".print tran";
            foreach $field (@headerfields)
            {
                print CIRFILE2 " $field";
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

    # we have now created a new circuit file that should have a .print line that matches what the V(*) and I(*) version did
    $retval=$Tools->wrapXyce($XYCE,$CIRFILE2);
    if ($retval != 0) { print "Exit code = $retval\n"; exit $retval; }
    if (not -s "$CIRFILE2.prn" ) { print "Exit code = 14\n"; exit 14; }

    # Have to use the faked cirfile here so that xyce_verify gets the right header expectations
    $CMD="$XYCE_VERIFY $CIRFILE2 $PRNOUT $CIRFILE2.prn > $CIRFILE.prn.out 2> $CIRFILE.prn.err";
    $retcode=system($CMD);
    $retval=2 if $retcode != 0;
        
}


print "Exit code = $retval\n";
exit $retval;
