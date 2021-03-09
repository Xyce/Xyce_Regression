#!/usr/bin/env perl

use Cwd;

use XyceRegression::Tools;

$Tools = XyceRegression::Tools->new();

# The input arguments to this script are:
# $ARGV[0] = location of Xyce binary
# $ARGV[1] = location of xyce_verify.pl script
# $ARGV[2] = location of compare script 
# $ARGV[3] = location of circuit file to test
# $ARGV[4] = location of gold standard prn file

$XYCE=$ARGV[0];
$XYCE_VERIFY=$ARGV[1];
$XYCE_COMPARE=$ARGV[2];
$CIRFILE=$ARGV[3];
$GOLDPRN=$ARGV[4];

$CIRFILEPY="python_tfdnn_rlc_series_vccs.cir";
$CIRFILEGOLD="rlc_series_vccs_nogenext.cir";

$TESTROOT = cwd;
print "TESTROOT = $TESTROOT\n";

# DEBUG: paths are hardcoded!
$PREFIX="";
$XYCEROOT="missing ";

print "XYCE = $XYCE\n";

# Try to decode Xyce root directory by stripping off bin/Xyce or src/Xyce
$XYCE =~ m/([^\/]*)(.*)\/bin\/Xyce.*/;
if (-d "$2") { $PREFIX=$1; $XYCEROOT=$2; }

$XYCE =~ m/([^\/]*)(.*)\/src\/Xyce.*/;
if (-d "$2") { $PREFIX=$1; $XYCEROOT=$2; }

print "XYCEROOT = $XYCEROOT\n";

#Check if we need a ".exe" extension (simply check for cygwin in uname)
$EXT="";
$result=system("uname | grep -i -q cygwin");
if ($result == 0)
{
  $EXT=".exe";
}

# set build dir and bin name
$MAKEROOT = "$XYCEROOT/src/test/GenExtTestHarnesses/";
#UGH
if (-d "$MAKEROOT/CMakeFiles")
{
  $EXT="";
}
$TestProgram="pythonGenCoup$EXT";
$XYCE_LIBTEST = "$MAKEROOT/$TestProgram";

if (-d "$MAKEROOT") {
  if (-e "$MAKEROOT/Makefile") {
    chdir($MAKEROOT);
    print "NOTICE:   make -------------------------\n";
    $result += system("make $TestProgram");
    if($result) {
      print "WARNING:  make failures! ---------------\n";
      $retval = $result;
    }
  } elsif (-d "$MAKEROOT/CMakeFiles") {
    chdir($XYCEROOT);
    print "Building $TestProgram in $MAKEROOT\n";
    $result += system("cmake --build . --target $TestProgram");
    if($result) {
      print "WARNING:  build failures! ---------------\n";
      $retval = $result;
    }
  } else {
    print "ERROR:    No build files!\n";
    $retval = 1;
  }
  chdir($TESTROOT);
} else {
    print "ERROR:    cannot chdir to $MAKEROOT\n";
  $retval = 1;
}


# Run the pythonGenCoup version:
if (-x $XYCE_LIBTEST) {
  print "NOTICE:   running ----------------------\n";
  $CMD="$XYCE_LIBTEST $CIRFILEPY > $CIRFILEPY.out 2> $CIRFILEPY.err";
  print "$CMD\n";
  $result = system("$CMD");
  if ($result == 0){ $retval=0;} else {$retval=10;}

} else {
  print "ERROR:    cannot find $XYCE_LIBTEST\n";
  $retval = 1;
}

if ($retval==0)
{
# Now run the Xyce-only version
    print "NOTICE:   running Xyce equivalent----------------------\n";
    $CMD="$XYCE $CIRFILEGOLD > $CIRFILEGOLD.out 2> $CIRFILEGOLD.err";
    $result = system("$CMD");
    if ($result == 0){ $retval=0;} else {$retval=10;}
}

# Now compare them:
if ($retval==0 && $result == 0)
{
    print "NOTICE:  Comparing ------------------------------------\n";
    $CMD="$XYCE_VERIFY $CIRFILEPY $CIRFILEGOLD.prn $CIRFILEPY.prn > $CIRFILEPY.prn.out 2> $CIRFILEPY.prn.err";
    $result = system("$CMD");
    if ($result == 0)
    { 
        # Comparison passed... but did we get any warnings about duplicate 
        # lines?
        $CMD="grep 'WARNING.*Throwing away line with duplicate' $CIRFILEPY.prn.err";
        $result= system("$CMD");
        if ( $result==0)
        {
            #Found such a line, report as failure.
            print STDERR "Comparison passed between Xyce-only and GenExt test output, but duplicate lines present so marking as failure.\n";
            $retval=2;
        }
        else
        {
            $retval=0;
        }
    } 
    else 
    {
        print STDERR "Comparison failed between Xyce-only and GenExt test output.\n";
        $retval=2;
    }
}    

print "Exit code = $retval\n"; exit $retval;

