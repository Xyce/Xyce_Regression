#!/bin/sh

# The input arguments to this script are:
# $1 = location of Xyce binary
# $2 = location of xyce_verify.pl script
# $3 = location of compare script 
# $4 = location of circuit file to test
# $5 = location of gold standard prn file

# If Xyce does not produce a prn file, then we return exit code 10.
# If Xyce succeeds, but the test fails, then we return exit code 2.
# If the shell script fails for some reason, then we return exit code 1.
# Otherwise we return the exit code of compare or xyce_verify.pl

# Since the shell script runs Xyce also, it is responsible for capturing any
# error output from Xyce.  The script run_xyce_regression captures the test
# output and handles the resulting files.  

XYCE=$1
XYCE_VERIFY=$2
#XYCE_COMPARE=$3
#CIRFILE=$4
#GOLDPRN=fullWaveRectDiode.cir.SENS.prn.gs
CIR1=fullWaveRectDiodeAdjoint.cir
CIR2=fullWaveRectDiodeDirect.cir
CIR3=fullWaveDummy.cir

$XYCE $CIR1 > $CIR1.out 2> $CIR1.err
if [ "$?" -ne "0" ]; then
  echo "Exit code = 10"
  exit 10
fi
if [ ! -f $CIR1.TRADJ.prn ]; then
  echo "Exit code = 14"
  exit 14
fi

$XYCE $CIR2 > $CIR2.out 2> $CIR2.err
if [ "$?" -ne "0" ]; then
  echo "Exit code = 10"
  exit 10
fi
if [ ! -f $CIR2.SENS.prn ]; then
  echo "Exit code = 14"
  exit 14
fi

sed '1 s/^.*$/Index       TIME           objective  derivative /g' $CIR1.TRADJ.prn > $CIR1.TRADJ.prn2
sed '1 s/^.*$/Index       TIME           objective  derivative /g' $CIR2.SENS.prn > $CIR2.SENS.prn2

#$XYCE_VERIFY --printline=sens  $CIR3 $CIR1.TRADJ.prn2 $CIR2.SENS.prn2
$XYCE_VERIFY $CIR3 $CIR1.TRADJ.prn2 $CIR2.SENS.prn2

EXITCODE=$?
if [ $EXITCODE -eq  0 ]; then
    echo "Exit code = 0"
    exit 0
else
    echo "Exit code = 2"
    exit 2
fi;

