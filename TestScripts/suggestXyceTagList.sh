#!/bin/sh

# First argument should be a path to a Xyce binary
# The capabilities of this binary will be queried and we will emit
# a suggested tags list appropriate for the most comprehensive testing of that
# binary

# one may also add a "-w" (for weekly) option to generate tags to run longer
# tests

usage()
{
    echo "Usage:  `basename $0` [options] <xyce binary path>"
    echo "  -w selects longer (weekly) tests"
    echo "  -a selects both longer (weekly) tests and shorter (nightly)"
    return
}

if [ $# -lt 1 ]
then
    usage
    exit 1
fi

TESTSET="+nightly"
while getopts wa option
do
    case "$option" in
        w) TESTSET="+weekly";;
        a) TESTSET="?nightly?weekly";; 
        [?]) usage
             exit 1;
             ;;
    esac
done
shift `echo $OPTIND-1 | bc`

XYCE_BINARY=$1
TMP_CAPABILITIES_FILE=/tmp/Xyce_capabilities.$$
# Get capabilities
$XYCE_BINARY -capabilities > $TMP_CAPABILITIES_FILE 2>&1

TAGLIST="$TESTSET"
TAGLIST_NONFREE_SHOULDFAIL=""
TAGLIST_RAD_SHOULDFAIL=""

# Check serial or parallel:
grep 'Parallel with MPI' $TMP_CAPABILITIES_FILE >/dev/null 2>&1
if [ $? = 0 ]
then
    # For parallel runs we'll later have klu/noklu versions of each tags list
    TAGLIST="${TAGLIST}+parallel"
    PARALLEL=1
else
    # for serial runs, always add "?klu"
    TAGLIST="${TAGLIST}+serial?klu"
    PARALLEL=0
fi

# Verbosity
grep 'Verbose' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?verbose-noverbose"
else
    TAGLIST="${TAGLIST}-verbose?noverbose"
fi

# FFT 
grep 'FFT' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?fft"
fi
#Now tests that depend on specific compiler usage (C++11, 14, etc.)
grep 'C++11' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?cxx11"
fi
grep 'C++14' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?cxx14"
fi
grep 'Stokhos enabled' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?stokhos"
fi

#SPECIAL CASE:  For Dakota builds, we ONLY run Dakota tests, so use "+" here.
grep 'Dakota' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}+dakota"
fi

# XDM tests are only run if we can find the xdm_bdl program in our path
xdm_bdl -h > /dev/null 2>&1
if test $? = 0
then
    TAGLIST="${TAGLIST}?xdm"
fi

# Tags that depend on what sort of build we are (full, norad, opensource)
# should be set last, because they work by creating a second tags list
 # based on what we've done so far.  If we do these earlier, some tests
# can fall through the cracks.

# ADMS models are compiled in by default, but sometimes developers shut them
# off to speed up builds
grep 'Verilog-A' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?adms"
else
    TAGLIST="${TAGLIST}-adms"
fi

# Analytic sensitivity code can be slow to compile and takes a lot of
# memory (or at least it used to).  Some users on tiny machines might turn
# it off.
grep 'sensitivities in ADMS' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?admssens"
else
    TAGLIST="${TAGLIST}-admssens"
fi

# NonFree models
BUILD_IS_OS=0
grep 'Non-Free device models' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?nonfree"
else
    # Tests that should fail
    TAGLIST_NONFREE_SHOULDFAIL="${TAGLIST}+nonfree"
    # Tests that should pass
    TAGLIST="${TAGLIST}-nonfree"
    BUILD_IS_OS=1
fi

# SandiaModels
BUILD_IS_UUR=0
grep 'Radiation models' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?rad"
    # Grumble.  Weekly "Customer Circuits" tests are only run on full builds
    if [ "${TESTSET}" = "Weekly" ]
    then
        TAGLIST="${TAGLIST}?customercircuits"
    fi
else
    TAGLIST_RAD_SHOULDFAIL="${TAGLIST}+rad"
    TAGLIST="${TAGLIST}-rad"
    BUILD_IS_UUR=1
fi

# ATHENA
grep 'ATHENA' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    TAGLIST="${TAGLIST}?athena"
else
    # Can't have athena without rad, so that's already taken care of
    TAGLIST_RAD_SHOULDFAIL="${TAGLIST_RAD_SHOULDFAIL}?athena"
    TAGLIST="${TAGLIST}-athena"
fi

# Tests tagged as "required:qaspr" all require the reaction parser,
# but also are all tagged as "required:rad", so must be handled
# specially
grep 'Reaction parser' $TMP_CAPABILITIES_FILE>/dev/null 2>&1
if [ $? = 0 ]
then
    if [ $BUILD_IS_UUR -eq 0 ]
    then
        TAGLIST="${TAGLIST}?qaspr"
    else
        TAGLIST_RAD_SHOULDFAIL="${TAGLIST_RAD_SHOULDFAIL}?qaspr"
        TAGLIST="${TAGLIST}-qaspr"
    fi
fi

#Now output the tags lists
if [ $PARALLEL = 1 ]
then
    echo "TAGLIST=${TAGLIST}-klu"
else
    echo "TAGLIST=${TAGLIST}"
fi

if [ "x${TAGLIST_NONFREE_SHOULDFAIL}" != "x" ]
then
    echo "TAGLIST_NONFREE_SHOULDFAIL=${TAGLIST_NONFREE_SHOULDFAIL}"
fi
if [ "x${TAGLIST_RAD_SHOULDFAIL}" != "x" ]
then
    echo "TAGLIST_RAD_SHOULDFAIL=${TAGLIST_RAD_SHOULDFAIL}"
fi

# Now emit +klu versions for parallel:
if [ $PARALLEL = 1 ]
then
    echo "TAGLIST_KLU=${TAGLIST}+klu"
    PbSrTAGLIST=`echo $TAGLIST|sed -e 's/+parallel/+serial/'`
    PbSrTAGLIST=`echo $PbSrTAGLIST|sed -e 's/?fft/-fft/'`
    PbSrTAGLIST="${PbSrTAGLIST}?ac?mpde?hb"
    echo "TAGLIST_PbSr=${PbSrTAGLIST}"

    if [ "x${TAGLIST_NONFREE_SHOULDFAIL}" != "x" ]
    then
        echo "TAGLIST_NONFREE_SHOULDFAIL_KLU=${TAGLIST_NONFREE_SHOULDFAIL}+klu"
    fi
    if [ "x${TAGLIST_RAD_SHOULDFAIL}" != "x" ]
    then
        echo "TAGLIST_RAD_SHOULDFAIL_KLU=${TAGLIST_RAD_SHOULDFAIL}+klu"
    fi

fi
rm -f $TMP_CAPABILITIES_FILE
