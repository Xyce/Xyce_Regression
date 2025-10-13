How to run the test suite using cmake and ctest

The tests in the Xyce_Regression repository, and dependent repositories,
can be run with ctest from a build of Xyce.  See this document in the
Xyce repository for instructions: Xyce/test/ReadMe_RegressionTesting.txt

The tests in this repository and dependent test repositories can also be
run with ctest on an installed copy of Xyce.  In this case, rather than
Xyce's build flags constraining the selection of appropriate tests, the
CMakeLists.txt file in Xyce_Regression will probe the installed copy of
Xyce for its supported capabilities.  Additionally, checks of the test
environment for test dependencies like Python will also be done to limit
testing to only those tests that can be logically supported.

Here are the steps to use ctest and this repository on an installed copy of Xyce.

1. Make a directory to hold the testing results and change to that directory.

   mkdir XyceTesting 
   cd XyceTesting
   
2. Call cmake on the Xyce_Regression directory with either Xyce already on your path 
   or use CMAKE_PREFIX_PATH to poing to where Xyce is installed.  For example:
   
   cmake -DCMAKE_PREFIX_PATH=/path/to/xyce/bin/ /path/to/Xyce_Regression
   
   Adding "--log-level=DEBUG" to the invocation of cmake will display debug information 
   on the capabilities that are identified as enabled in Xyce. 
   
3. If that step finishes without error you can run all the tests with the "nightly" label with:

   ctest -L nightly -j 8
   
   Note the "-j 8" runs 8 testing jobs in parallel.  Running testing jobs in parallel 
   will greatly speed up testing.  Also, the option "--no-label-summary" will suppress 
   the printing of a labels found summary at the end of a successful test run.  
   
   
See Xyce/test/ReadMe_RegressionTesting.txt for more details on using
ctest to selecting which tests to run.

Limitations:  In its current form, the parallel testing assumes that "mpiexec" is used 
to launch Xyce and that "mpiexec" is on the path. 

