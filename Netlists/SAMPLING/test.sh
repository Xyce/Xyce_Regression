#!/usr/bin/env perl

$CIRFILE="globalParamNormalMC.cir";

# Read in the Xyce std output and locate various statistical moments of R1
$R1mean=`grep -m 1 'mean of {R1:R}' $CIRFILE.out`;
chomp($R1mean);
$R1mean=~ s/MC sampling mean of \{R1:R\} = ([0-9]*)/\1/;
print "R1 mean is $R1mean\n";

$R1variance=`grep -m 1 'variance of {R1:R}' $CIRFILE.out`;
chomp($R1variance);
$R1variance=~ s/MC sampling variance of \{R1:R\} = ([0-9]*)/\1/;
print "R1 variance is $R1variance\n";

$R1stddev=`grep -m 1 'stddev of {R1:R}' $CIRFILE.out`;
chomp($R1stddev);
$R1stddev=~ s/MC sampling stddev of \{R1:R\} = ([0-9]*)/\1/;
print "R1 stddev is $R1stddev\n";

$R1skew=`grep -m 1 'skew of {R1:R}' $CIRFILE.out`;
chomp($R1skew);
$R1skew=~ s/MC sampling skew of \{R1:R\} = ([0-9]*)/\1/;
print "R1 skew is $R1skew\n";

$R1kurtosis=`grep -m 1 'kurtosis of {R1:R}' $CIRFILE.out`;
chomp($R1kurtosis);
$R1kurtosis=~ s/MC sampling kurtosis of \{R1:R\} = ([0-9]*)/\1/;
print "R1 kurtosis is $R1kurtosis\n";


# Read in the Xyce std output and locate various statistical moments of V(1)
$V1mean=`grep -m 1 'mean of {V(1)}' $CIRFILE.out`;
chomp($V1mean);
$V1mean=~ s/MC sampling mean of \{V\(1\)\} = ([0-9]*)/\1/;
print "V(1) mean is $V1mean\n";

$V1variance=`grep -m 1 'variance of {V(1)}' $CIRFILE.out`;
chomp($V1variance);
$V1variance=~ s/MC sampling variance of \{V\(1\)\} = ([0-9]*)/\1/;
print "V(1) variance is $V1variance\n";

$V1stddev=`grep -m 1 'stddev of {V(1)}' $CIRFILE.out`;
chomp($V1stddev);
$V1stddev=~ s/MC sampling stddev of \{V\(1\)\} = ([0-9]*)/\1/;
print "V(1) stddev is $V1stddev\n";

$V1skew=`grep -m 1 'skew of {V(1)}' $CIRFILE.out`;
chomp($V1skew);
$V1skew=~ s/MC sampling skew of \{V\(1\)\} = ([0-9]*)/\1/;
print "V(1) skew is $V1skew\n";

$V1kurtosis=`grep -m 1 'kurtosis of {V(1)}' $CIRFILE.out`;
chomp($V1kurtosis);
$V1kurtosis=~ s/MC sampling kurtosis of \{V\(1\)\} = ([0-9]*)/\1/;
print "V(1) kurtosis is $V1kurtosis\n";

$R1_analytical_mean = 1.0e+3;
$R1_analytical_stddev = 1e+2;
$R1_analytical_variance = 1e+4;
$R1_analytical_skew = 0.0;
$R1_analytical_kurtosis = 3.0;

$V1_analytical_mean = 875.0;
$V1_analytical_stddev = 10.93;
$V1_analytical_variance = 119.62;
$V1_analytical_skew = 0.0;
$V1_analytical_kurtosis = 3.0;

$passed=1;

$reltol=1e-3;

print "\n";
$result1 = abs($R1mean-$R1_analytical_mean)/abs($R1mean);
print "R1 mean result = $result1 \n"; 

if (abs($R1mean-$R1_analytical_mean)/abs($R1mean) >= $reltol)
{
  print "failed 1\n";
  $result = abs($R1mean-$R1_analytical_mean)/abs($R1mean);
  print "result = $result \n";
  print "R1mean = $R1mean\n";
  print "R1_analytical_mean = $R1_analytical_mean\n";
  $passed=0;
}

$result2 = abs($R1stddev-$R1_analytical_stddev)/abs($R1stddev);
print "R1 stddev result = $result2 \n";

if (abs($R1stddev-$R1_analytical_stddev)/abs($R1stddev) >= $reltol)
{
  print "failed 2\n";
  $passed=0;
}

$result3 = abs($V1mean-$V1_analytical_mean)/abs($V1mean);
print "V1 mean result = $result3 \n"; 

if (abs($V1mean-$V1_analytical_mean)/abs($V1mean) >= $reltol)
{
  print "failed 3\n";
  $result = abs($V1mean-$V1_analytical_mean)/abs($V1mean);
  print "result = $result \n";
  print "V1mean = $V1mean\n";
  print "V1_analytical_mean = $V1_analytical_mean\n";
  $passed=0;
}

$result4 = abs($V1stddev-$V1_analytical_stddev)/abs($V1stddev);
print "V1 stddev result = $result4 \n";

if (abs($V1stddev-$V1_analytical_stddev)/abs($V1stddev) >= $reltol)
{
  print "failed 4\n";
  $passed=0;
}

#If this is a VALGRIND run, we don't do our normal verification, we
# merely run "valgrind_check.sh" as if it were xyce_verify.pl

if ($XYCE_VERIFY =~ m/valgrind_check/)
{
    print STDERR "DOING VALGRIND RUN INSTEAD OF REAL RUN!";
    if (system("$XYCE_VERIFY $CIRFILE junk $CIRFILE.prn > $CIRFILE.prn.out 2>&1 $CIRFILE.prn.err"))
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


if ($passed==1)
{
#    print STDERR "Ran $num_tries, passed the last one.\n";
    print "Exit code = 0\n";
    exit 0;
}
else
{
#    print STDERR "Ran $num_tries times, failed all of them.\n";
    print "Exit code = 2\n";
    exit 2;
}

