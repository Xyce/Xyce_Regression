
# A python script that gathers run time output from Xyce and stores 
# the results in a Pandas table for later querry.
# Data collected includes runtimes, device counts, iteration counts
# and extra output from parallel runs 

import os.path
import argparse
from pathlib import Path
import shutil
import re
import pandas
import os
import datetime


def GatherPerformanceData():
  """ Gathers data from an output directory of test results.
  
  This function decends into a test output directory and from each *.out file
  gathers runtime data on Xyce.  The collected data is stored in a pandas table
  which is saved to the current directory
  
  Arguments:
    --output <directory where test outputs  reside>
      Defaults to XycePerformanceOutput if not specified.
    --file <filename for saved results>
      Defaults to XycePerformanceData.csv if not specified. 
    -v, --verbose  Generate verbose output.
    
  """
  # load up argument parser with data
  parser = argparse.ArgumentParser()
  parser.add_argument("--output", help="Directory where test outputs reside.", default="XycePerformanceOutput")
  parser.add_argument("--file", help="File name used to save collected data.", default="XycePerformanceOutput.csv")
  parser.add_argument("--sysname", help="System name used to use in place of local hostname.", default="hostname")
  parser.add_argument("--compiler", help="Compiiler name used to use in the build.", default="unknown")
  parser.add_argument("--date", help="Date to use for data. Overides data in outpu files.", default="today")
  parser.add_argument("-v", "--verbose", help="verbose output", action="store_true")
  # get the command line arguments
  args = parser.parse_args()
    
  # get the output directory
  XycePerformanceOutput = args.output
  if args.verbose:
    print("Searching for output in %s" % (XycePerformanceOutput))
  
  if( not os.path.exists( XycePerformanceOutput)):
    print( "Error: testing output directory does not exist %s" % (XycePerformanceOutput))
    return -1
  if( not os.path.isdir( XycePerformanceOutput)):
    print( "Error: testing output specified is not a directory  %s" % (XycePerformanceOutput))
    return -1
  
  systemName = args.sysname
  if systemName == 'hostname':
    systemName = os.uname().nodename
  
  resultsFileName = args.file
  compilerName = args.compiler
  
  reportDate = args.date
  if (reportDate == "today"):
    reportDate = datetime.date.today()
    
  reportDate = pandas.to_datetime(reportDate)
    
  testList = getOutputsInDirectory(XycePerformanceOutput, fileSuffix=".out")
  if args.verbose:
    print("Found %d output files." %(len(testList)))
    
  # this is an array of the column names to be used in the final data table.
  # parallel runs have 208 more data columns.  I could probably ingest this from 
  # the data files but it's good to have the receiving pandas table ready
  DataColumnLables = ['TestFileName', 'Machine', 'Compiler', 'Date', 'XyceVersion', 'DeviceCount', 'NumberOfUnknowns', 'SetUpTime', 
    'DCOpTime', 'DCOPNumberSucSteps', 'DCOPNumberFailStepsAtt', 'DCOPNumberJacEval', 'DCOPNumberLinSolv', 'DCOPNumberFailedSolv', 'DCOPNumberResidualEval', 'DCOPNumberConvFail', 
    'TranStepTime', 'TranNumberSucSteps', 'TranNumberFailStepsAtt', 'TranNumberJacEval', 'TranNumberLinSolv', 'TranNumberFailedSolv', 'TranNumberResidualEval', 'TranNumberConvFail', 'TranResidualLoadTime', 'TranJacLoadTime', 'TranLinSolveTime', 
    'SummaryNumberSucSteps', 'SummaryNumberFailStepsAtt', 'SummaryNumberJacEval', 'SummaryNumberLinSolv', 'SummaryNumberFailedSolv', 'SummaryNumberResidualEval', 'SummaryNumberConvFail', 'SummaryResidualLoadTime', 'SummaryJacLoadTime', 'SummaryLinSolveTime', 
    'TotalSimSolvTime', 'TotalElapRunTime', 
    'XyceCount', 'XyceCPUTime', 'XyceCPUTimePct', 'XyceWallTime', 'XyceWallTimePct', 'AnalysisCount', 'AnalysisCPUTime', 'AnalysisCPUTimePct', 'AnalysisWallTime', 'AnalysisWallTimePct', 'TransientCount', 'TransientCPUTime', 'TransientCPUTimePct', 'TransientWallTime', 'TransientWallTimePct', 'NonlinearSolveCount', 'NonlinearSolveCPUTime', 'NonlinearSolveCPUTimePct', 'NonlinearSolveWallTime', 'NonlinearSolveWallTimePct', 'ResidualCount', 'ResidualCPUTime', 'ResidualCPUTimePct', 'ResidualWallTime', 'ResidualWallTimePct', 'JacobianCount', 'JacobianCPUTime', 'JacobianCPUTimePct', 'JacobianWallTime', 'JacobianWallTimePct', 'SuccessfulStepCount', 'SuccessfulStepCPUTime', 'SuccessfulStepCPUTimePct', 'SuccessfulStepWallTime', 'SuccessfulStepWallTimePct', 'FailedStepsCount', 'FailedStepsCPUTime', 'FailedStepsCPUTimePct', 'FailedStepsWallTime', 'FailedStepsWallTimePct', 'NetlistImportCount', 'NetlistImportCPUTime', 'NetlistImportCPUTimePct', 'NetlistImportWallTime', 'NetlistImportWallTimePct', 'ParseContextCount', 'ParseContextCPUTime', 'ParseContextCPUTimePct', 'ParseContextWallTime', 'ParseContextWallTimePct', 'DistributeDevicesCount', 'DistributeDevicesCPUTime', 'DistributeDevicesCPUTimePct', 'DistributeDevicesWallTime', 'DistributeDevicesWallTimePct', 'VerifyDevicesCount', 'VerifyDevicesCPUTime', 'VerifyDevicesCPUTimePct', 'VerifyDevicesWallTime', 'VerifyDevicesWallTimePct', 'InstantiateCount', 'InstantiateCPUTime', 'InstantiateCPUTimePct', 'InstantiateWallTime', 'InstantiateWallTimePct', 'LateInitializationCount', 'LateInitializationCPUTime', 'LateInitializationCPUTimePct', 'LateInitializationWallTime', 'LateInitializationWallTimePct', 'GlobalIndicesCount', 'GlobalIndicesCPUTime', 'GlobalIndicesCPUTimePct', 'GlobalIndicesWallTime', 'GlobalIndicesWallTimePct', 'SetupMatrixStructureCount', 'SetupMatrixStructureCPUTime', 'SetupMatrixStructureCPUTimePct', 'SetupMatrixStructureWallTime', 'SetupMatrixStructureWallTimePct', 
    'NumProc', 'XycePCount', 'XyceSumCPUTime', 'XyceSumCPUTimePct', 'XyceMinCPUTime', 'XyceMinCPUTimePct', 'XyceMaxCPUTime', 'XyceMaxCPUTimePct', 'XyceSumWallTime', 'XyceSumWallTimePct', 'XyceMinWallTime', 'XyceMinWallTimePct', 'XyceMaxWallTime', 'XyceMaxWallTimePct', 'AnalysisPCount', 'AnalysisSumCPUTime', 'AnalysisSumCPUTimePct', 'AnalysisMinCPUTime', 'AnalysisMinCPUTimePct', 'AnalysisMaxCPUTime', 'AnalysisMaxCPUTimePct', 'AnalysisSumWallTime', 'AnalysisSumWallTimePct', 'AnalysisMinWallTime', 'AnalysisMinWallTimePct', 'AnalysisMaxWallTime', 'AnalysisMaxWallTimePct', 'TransientPCount', 'TransientSumCPUTime', 'TransientSumCPUTimePct', 'TransientMinCPUTime', 'TransientMinCPUTimePct', 'TransientMaxCPUTime', 'TransientMaxCPUTimePct', 'TransientSumWallTime', 'TransientSumWallTimePct', 'TransientMinWallTime', 'TransientMinWallTimePct', 'TransientMaxWallTime', 'TransientMaxWallTimePct', 'NonlinearSolvePCount', 'NonlinearSolveSumCPUTime', 'NonlinearSolveSumCPUTimePct', 'NonlinearSolveMinCPUTime', 'NonlinearSolveMinCPUTimePct', 'NonlinearSolveMaxCPUTime', 'NonlinearSolveMaxCPUTimePct', 'NonlinearSolveSumWallTime', 'NonlinearSolveSumWallTimePct', 'NonlinearSolveMinWallTime', 'NonlinearSolveMinWallTimePct', 'NonlinearSolveMaxWallTime', 'NonlinearSolveMaxWallTimePct', 'ResidualPCount', 'ResidualSumCPUTime', 'ResidualSumCPUTimePct', 'ResidualMinCPUTime', 'ResidualMinCPUTimePct', 'ResidualMaxCPUTime', 'ResidualMaxCPUTimePct', 'ResidualSumWallTime', 'ResidualSumWallTimePct', 'ResidualMinWallTime', 'ResidualMinWallTimePct', 'ResidualMaxWallTime', 'ResidualMaxWallTimePct', 'JacobianPCount', 'JacobianSumCPUTime', 'JacobianSumCPUTimePct', 'JacobianMinCPUTime', 'JacobianMinCPUTimePct', 'JacobianMaxCPUTime', 'JacobianMaxCPUTimePct', 'JacobianSumWallTime', 'JacobianSumWallTimePct', 'JacobianMinWallTime', 'JacobianMinWallTimePct', 'JacobianMaxWallTime', 'JacobianMaxWallTimePct', 'SuccessfulStepPCount', 'SuccessfulStepSumCPUTime', 'SuccessfulStepSumCPUTimePct', 'SuccessfulStepMinCPUTime', 'SuccessfulStepMinCPUTimePct', 'SuccessfulStepMaxCPUTime', 'SuccessfulStepMaxCPUTimePct', 'SuccessfulStepSumWallTime', 'SuccessfulStepSumWallTimePct', 'SuccessfulStepMinWallTime', 'SuccessfulStepMinWallTimePct', 'SuccessfulStepMaxWallTime', 'SuccessfulStepMaxWallTimePct', 'FailedStepsPCount', 'FailedStepsSumCPUTime', 'FailedStepsSumCPUTimePct', 'FailedStepsMinCPUTime', 'FailedStepsMinCPUTimePct', 'FailedStepsMaxCPUTime', 'FailedStepsMaxCPUTimePct', 'FailedStepsSumWallTime', 'FailedStepsSumWallTimePct', 'FailedStepsMinWallTime', 'FailedStepsMinWallTimePct', 'FailedStepsMaxWallTime', 'FailedStepsMaxWallTimePct', 'NetlistImportPCount', 'NetlistImportSumCPUTime', 'NetlistImportSumCPUTimePct', 'NetlistImportMinCPUTime', 'NetlistImportMinCPUTimePct', 'NetlistImportMaxCPUTime', 'NetlistImportMaxCPUTimePct', 'NetlistImportSumWallTime', 'NetlistImportSumWallTimePct', 'NetlistImportMinWallTime', 'NetlistImportMinWallTimePct', 'NetlistImportMaxWallTime', 'NetlistImportMaxWallTimePct', 'ParseContextPCount', 'ParseContextSumCPUTime', 'ParseContextSumCPUTimePct', 'ParseContextMinCPUTime', 'ParseContextMinCPUTimePct', 'ParseContextMaxCPUTime', 'ParseContextMaxCPUTimePct', 'ParseContextSumWallTime', 'ParseContextSumWallTimePct', 'ParseContextMinWallTime', 'ParseContextMinWallTimePct', 'ParseContextMaxWallTime', 'ParseContextMaxWallTimePct', 'DistributeDevicesPCount', 'DistributeDevicesSumCPUTime', 'DistributeDevicesSumCPUTimePct', 'DistributeDevicesMinCPUTime', 'DistributeDevicesMinCPUTimePct', 'DistributeDevicesMaxCPUTime', 'DistributeDevicesMaxCPUTimePct', 'DistributeDevicesSumWallTime', 'DistributeDevicesSumWallTimePct', 'DistributeDevicesMinWallTime', 'DistributeDevicesMinWallTimePct', 'DistributeDevicesMaxWallTime', 'DistributeDevicesMaxWallTimePct', 'VerifyDevicesPCount', 'VerifyDevicesSumCPUTime', 'VerifyDevicesSumCPUTimePct', 'VerifyDevicesMinCPUTime', 'VerifyDevicesMinCPUTimePct', 'VerifyDevicesMaxCPUTime', 'VerifyDevicesMaxCPUTimePct', 'VerifyDevicesSumWallTime', 'VerifyDevicesSumWallTimePct', 'VerifyDevicesMinWallTime', 'VerifyDevicesMinWallTimePct', 'VerifyDevicesMaxWallTime', 'VerifyDevicesMaxWallTimePct', 'InstantiatePCount', 'InstantiateSumCPUTime', 'InstantiateSumCPUTimePct', 'InstantiateMinCPUTime', 'InstantiateMinCPUTimePct', 'InstantiateMaxCPUTime', 'InstantiateMaxCPUTimePct', 'InstantiateSumWallTime', 'InstantiateSumWallTimePct', 'InstantiateMinWallTime', 'InstantiateMinWallTimePct', 'InstantiateMaxWallTime', 'InstantiateMaxWallTimePct', 'LateInitializationPCount', 'LateInitializationSumCPUTime', 'LateInitializationSumCPUTimePct', 'LateInitializationMinCPUTime', 'LateInitializationMinCPUTimePct', 'LateInitializationMaxCPUTime', 'LateInitializationMaxCPUTimePct', 'LateInitializationSumWallTime', 'LateInitializationSumWallTimePct', 'LateInitializationMinWallTime', 'LateInitializationMinWallTimePct', 'LateInitializationMaxWallTime', 'LateInitializationMaxWallTimePct', 'GlobalIndicesPCount', 'GlobalIndicesSumCPUTime', 'GlobalIndicesSumCPUTimePct', 'GlobalIndicesMinCPUTime', 'GlobalIndicesMinCPUTimePct', 'GlobalIndicesMaxCPUTime', 'GlobalIndicesMaxCPUTimePct', 'GlobalIndicesSumWallTime', 'GlobalIndicesSumWallTimePct', 'GlobalIndicesMinWallTime', 'GlobalIndicesMinWallTimePct', 'GlobalIndicesMaxWallTime', 'GlobalIndicesMaxWallTimePct', 'SetupMatrixStructurePCount', 'SetupMatrixStructureSumCPUTime', 'SetupMatrixStructureSumCPUTimePct', 'SetupMatrixStructureMinCPUTime', 'SetupMatrixStructureMinCPUTimePct', 'SetupMatrixStructureMaxCPUTime', 'SetupMatrixStructureMaxCPUTimePct', 'SetupMatrixStructureSumWallTime', 'SetupMatrixStructureSumWallTimePct', 'SetupMatrixStructureMinWallTime', 'SetupMatrixStructureMinWallTimePct', 'SetupMatrixStructureMaxWallTime', 'SetupMatrixStructureMaxWallTimePct' ]
  dataFrame = getPandasTable(resultsFileName, DataColumnLables)
  
  for adir, afile in testList:
    statsSet = getStatsFromOutput( adir, afile)
    # if Xyce failed to finish due to a system time limit then it will 
    # probably have only 3 of the needed data items in the output.
    # treat 3 or fewer as a simulation failure.
    if len(statsSet) > 4:
      statsSet['TestFileName'] = afile.removesuffix('.out')
      statsSet['Machine'] = systemName
      statsSet['Compiler'] = compilerName 
      statsSet['Date'] = reportDate
      numStats = len(statsSet)
      newDF = pandas.DataFrame( statsSet, index=range(0,1) )
      dataFrame = pandas.concat( [dataFrame, newDF], ignore_index=True )
      #print('Stats Found')
      #print(statsSet)
      #print(len(statsSet))
    else:
      print("*** Error in Xyce output file %s" % (os.path.join(adir,afile)))
    
  #print( dataFrame )
  dataFrame.to_csv( resultsFileName, index=False )
  print("Data saved to %s" %(resultsFileName))


  



    
def getOutputsInDirectory(topDir, fileSuffix=".out"):
  """
  Given a top level directory and an output file suffix find all the 
  output files that match
  """
  # good to start recursive directory search 
  pathObj = Path(topDir)
  # look for any files that match the name "tags" or "<filename>tags"
  outputFileList = pathObj.glob(os.path.join('**', '*' + fileSuffix) )
  foundFiles=[]
  # now we have an iterator for the files, so loop over it 
  for anOutputFile in outputFileList:
    #fullName = os.path.join(anOutputFile.parent, anOutputFile.name)
    foundFiles.append( (anOutputFile.parent, anOutputFile.name) )
  return foundFiles


def getStatsFromOutput( dirname, filename):
  # returns a dictionary of keyed by stat name of runtime stats from a Xyce output file.
  #
  # Scan Xyce output file for the following:
  #  This is version <xyce version info>
  #  Total Devices <device count>
  #  Number of Unknowns = <number of unknowns>
  #  Problem read in and set up time: <number> seconds 
  #  DCOP time: <number> seconds
  #  Number Successful Steps Taken: <number>
  #  Number Failed Steps Attempted: <number>
  #  Number Jacobians Evaluated: <number>
  #  Number Linear Solves: <number>
  #  Number Failed Linear Solves: <number> 
  #  Number Residual Evaluations: <number>
  #  Number Nonlinear Convergence Failures: <number>
  #  Total Residual Load Time: <time> seconds
  #  Total Jacobian Load Time: <time> seconds 
  #  Total Linear Solution Time: <time> seconds 
  #  Transient Stepping time: <time> seconds 
  #  Number Successful Steps Taken: <number>
  #  Number Failed Steps Attempted: <number>
  #  Number Jacobians Evaluated: <number>
  #  Number Linear Solves: <number>
  #  Number Failed Linear Solves: <number>
  #  Number Residual Evaluations: <number>
  #  Number Nonlinear Convergence Failures: <number>
  #  Total Residual Load Time: <time> seconds
  #  Total Jacobian Load Time: <time> seconds
  #  Total Linear Solution Time: <time> seconds
  #  Same data but for the solution summary 
  #  Total Simulation Solvers Run Time: <time> seconds 
  #  Total Elapsed Run Time: <time> seconds 
  # note the above has 3 sections separated by "DCOP", "Transient", "Solution Summary"
  # with duplicated names of metrics within each section.  Thus in reading a file this 
  # will need to track which section it is in.
  #
  # then there is a timing analysis breakdown that is expanded for parallel runs
  #
  #   Timing summary of 1 processor
  #                    Stats                   Count        CPU Time              Wall Time
  #   ---------------------------------------- ------ --------------------- ---------------------
  #   Xyce                                          1     1:41.439 (100.0%)     1:42.930 (100.0%)
  #     Analysis                                    1     1:40.974 (99.54%)     1:42.411 (99.50%)
  #       Transient                                 1     1:40.973 (99.54%)     1:42.411 (99.50%)
  #         Nonlinear Solve                     86840     1:21.362 (80.21%)     1:21.988 (79.65%)
  #           Residual                         174999       33.372 (32.90%)       33.604 (32.65%)
  #           Jacobian                          88158       25.734 (25.37%)       25.892 (25.16%)
  #           Linear Solve                      88158       12.084 (11.91%)       12.172 (11.83%)
  #         Successful DCOP Steps                   1        0.000 (<0.01%)        0.004 (<0.01%)
  #         Successful Step                     86838       13.347 (13.16%)       14.081 (13.68%)
  #         Failed Steps                            1        0.000 (<0.01%)        0.000 (<0.01%)
  #     Netlist Import                              1        0.406 ( 0.40%)        0.437 ( 0.42%)
  #       Parse Context                             1        0.002 (<0.01%)        0.004 (<0.01%)
  #       Distribute Devices                        1        0.322 ( 0.32%)        0.337 ( 0.33%)
  #       Verify Devices                            1        0.000 (<0.01%)        0.000 (<0.01%)
  #       Instantiate                               1        0.081 ( 0.08%)        0.083 ( 0.08%)
  #     Late Initialization                         1        0.058 ( 0.06%)        0.064 ( 0.06%)
  #       Global Indices                            1        0.037 ( 0.04%)        0.038 ( 0.04%)
  #     Setup Matrix Structure                      1        0.015 ( 0.01%)        0.017 ( 0.02%)
  #     
  #   and
  #   
  #   Timing summary of 4 processors
  #                                                        CPU Time              CPU Time              CPU Time              Wall Time             Wall Time             Wall Time
  #                    Stats                   Count   Sum (% of System)     Min (% of System)     Max (% of System)     Sum (% of System)     Min (% of System)     Max (% of System)
  #   ---------------------------------------- ----- --------------------- --------------------- --------------------- --------------------- --------------------- ---------------------
  #   Xyce                                         4        4.741 (100.0%)        1.147 (24.20%)        1.203 (25.38%)        5.195 (100.0%)        1.237 (23.82%)        1.482 (28.54%)
  #     Analysis                                   4        4.688 (98.89%)        1.133 (23.90%)        1.188 (25.07%)        4.840 (93.17%)        1.210 (23.29%)        1.210 (23.30%)
  #       Transient                                4        4.688 (98.88%)        1.133 (23.90%)        1.188 (25.07%)        4.840 (93.17%)        1.210 (23.29%)        1.210 (23.30%)
  #         Nonlinear Solve                    18684        3.778 (79.70%)        0.925 (19.51%)        0.954 (20.11%)        3.885 (74.78%)        0.971 (18.69%)        0.971 (18.70%)
  #           Residual                         37496        1.181 (24.92%)        0.288 ( 6.08%)        0.299 ( 6.30%)        1.212 (23.33%)        0.302 ( 5.81%)        0.304 ( 5.86%)
  #           Jacobian                         18812        0.461 ( 9.73%)        0.113 ( 2.39%)        0.118 ( 2.48%)        0.474 ( 9.13%)        0.116 ( 2.24%)        0.120 ( 2.32%)
  #           Linear Solve                     18812        0.665 (14.02%)        0.161 ( 3.40%)        0.170 ( 3.58%)        0.686 (13.20%)        0.170 ( 3.27%)        0.174 ( 3.35%)
  #         Successful Step                    18516        0.478 (10.09%)        0.108 ( 2.28%)        0.153 ( 3.23%)        0.514 ( 9.90%)        0.111 ( 2.14%)        0.181 ( 3.48%)
  #         Failed Steps                         168        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)
  #     Netlist Import                             4        0.010 ( 0.20%)        0.002 ( 0.04%)        0.003 ( 0.06%)        0.012 ( 0.23%)        0.003 ( 0.06%)        0.003 ( 0.06%)
  #       Parse Context                            4        0.002 ( 0.04%)        0.000 ( 0.00%)        0.001 ( 0.01%)        0.003 ( 0.05%)        0.001 ( 0.01%)        0.001 ( 0.01%)
  #       Distribute Devices                       4        0.002 ( 0.04%)        0.000 ( 0.00%)        0.001 ( 0.02%)        0.003 ( 0.05%)        0.001 ( 0.01%)        0.001 ( 0.01%)
  #       Verify Devices                           4        0.000 (<0.01%)        0.000 ( 0.00%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)
  #       Instantiate                              4        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)        0.000 (<0.01%)
  #     Late Initialization                        4        0.019 ( 0.40%)        0.005 ( 0.10%)        0.005 ( 0.10%)        0.019 ( 0.37%)        0.005 ( 0.09%)        0.005 ( 0.09%)
  #       Global Indices                           4        0.003 ( 0.05%)        0.001 ( 0.01%)        0.001 ( 0.01%)        0.003 ( 0.05%)        0.001 ( 0.01%)        0.001 ( 0.01%)
  #     Setup Matrix Structure                     4        0.004 ( 0.08%)        0.001 ( 0.02%)        0.001 ( 0.02%)        0.004 ( 0.08%)        0.001 ( 0.02%)        0.001 ( 0.02%)
  
  # getting the regex right for the timing summary lines right is complicated.  Here is the base one and the prefix will change for each match 
  timingLineCountRegex = '\s*([0-9]+)'
  timingLine4ValueRegex =  '\s*([0-9]*\:?[0-9]*\:?[0-9]*\.[0-9]*)\s\(([< ]*[0-9]*\.[0-9]*)%\)\s*([0-9]*\:?[0-9]*\:?[0-9]*\.[0-9]+)\s\(([< ]*[0-9]*\.[0-9]*)%\)'
  timingLine12ValueRegex =  timingLine4ValueRegex + timingLine4ValueRegex + timingLine4ValueRegex
  timingLine5ValueRegex = timingLineCountRegex + timingLine4ValueRegex
  timingLine13ValueRegex = timingLineCountRegex + timingLine12ValueRegex
  timingLine1ProcCols = ['Count', 'CPUTime', 'CPUTimePct', 'WallTime', 'WallTimePct']
  timingLineMultiProcCols = ['PCount', 'SumCPUTime', 'SumCPUTimePct', 'MinCPUTime', 'MinCPUTimePct', 'MaxCPUTime', 'MaxCPUTimePct', 'SumWallTime', 'SumWallTimePct', 'MinWallTime', 'MinWallTimePct', 'MaxWallTime', 'MaxWallTimePct']

  fullFileName = os.path.join(dirname, filename)
  print('Working on %s' % (fullFileName) )
  statsFound = {}
  xyceOutputFile = open(fullFileName)
  prefix=''
  for aLine in xyceOutputFile:
    if re.search('Exiting ', aLine):
      # Xyce exited due to an error.  Clear the stats found list and report and error
      statsFound.clear()
      print( "*** Xyce simulation exited with error on test %s " % (fullFileName) )
      xyceOutputFile.close()
      return statsFound
    aLine = aLine.strip()
    # look for Xyce version data
    if checkForTagInLine('This is version (\w*.*)', aLine, 'XyceVersion', statsFound):
      continue 
    if checkForTagInLine('Total Devices\s*(\d+)', aLine, 'DeviceCount', statsFound):
      continue 
    if checkForTagInLine('Number of Unknowns = (\d+)', aLine, 'NumberOfUnknowns', statsFound):
      continue 
    if checkForTagInLine('Problem read in and set up time:\s*([0-9]+\.?[0-9]+)', aLine, 'SetUpTime', statsFound):
      continue
    if checkForTagInLine('DCOP time:\s*([0-9]+\.?[0-9]+)', aLine, 'DCOpTime', statsFound):
      prefix='DCOP'
      continue
    if checkForTagInLine('Transient Stepping time:\s*([0-9]+\.?[0-9]+)', aLine, 'TranStepTime', statsFound):
      prefix='Tran'
      continue
    if aLine.strip() == '***** Solution Summary *****':
      prefix='Summary'
      continue 
    
    # these metrics repeat in the DC, Tran and Summary sections so the use of the prefix variable keeps them 
    # unique in the dictionary.
    if checkForTagInLine('Number Successful Steps Taken:\s*(\d+)', aLine, prefix + 'NumberSucSteps', statsFound):
      continue
    if checkForTagInLine('Number Failed Steps Attempted:\s*(\d+)', aLine, prefix + 'NumberFailStepsAtt', statsFound):
      continue
    if checkForTagInLine('Number Jacobians Evaluated:\s*(\d+)', aLine, prefix + 'NumberJacEval', statsFound):
      continue 
    if checkForTagInLine('Number Linear Solves:\s*(\d+)', aLine, prefix + 'NumberLinSolv', statsFound):
      continue 
    if checkForTagInLine('Number Failed Linear Solves:\s*(\d+)', aLine, prefix + 'NumberFailedSolv', statsFound):
      continue 
    if checkForTagInLine('Number Residual Evaluations:\s*(\d+)', aLine, prefix + 'NumberResidualEval', statsFound):
      continue 
    if checkForTagInLine('Number Nonlinear Convergence Failures:\s*(\d+)', aLine, prefix + 'NumberConvFail', statsFound):
      continue 
    if checkForTagInLine('Total Residual Load Time:\s*([0-9]+\.?[0-9]+)', aLine, prefix + 'ResidualLoadTime', statsFound):
      continue
    if checkForTagInLine('Total Jacobian Load Time:\s*([0-9]+\.?[0-9]+)', aLine, prefix + 'JacLoadTime', statsFound):
      continue
    if checkForTagInLine('Total Linear Solution Time:\s*([0-9]+\.?[0-9]+)', aLine, prefix + 'LinSolveTime', statsFound):
      continue
   
    # back to normal, non prefix dependent variables. 
    if checkForTagInLine('Total Simulation Solvers Run Time:\s*([0-9]+\.?[0-9]+)', aLine, 'TotalSimSolvTime', statsFound):
      continue
    if checkForTagInLine('Total Elapsed Run Time:\s*([0-9]+\.?[0-9]+)', aLine, 'TotalElapRunTime', statsFound):
      continue
    if checkForTagInLine('Timing summary of\s*([0-9]+)\s*processor[s]?', aLine, 'NumProc', statsFound):
      continue
      
    # a long set of timing metrics that are repeated in parallel First bloc is for proc 0 or the only proc in serial
    # use the same prefix trick to store these properly
    if re.search( 'Stats\s*Count\s*CPU Time\s*Wall Time', aLine):
      prefix='TSL'
      continue
    if re.search('Stats\s*Count\s*Sum \(% of System\)\s*Min \(% of System\)\s*Max \(% of System\)\s*Sum \(% of System\)\s*Min \(% of System\)\s*Max \(% of System\)', aLine):
      prefix='TSP'
      continue
    if prefix == 'TSL':
      if checkForMulitDataInLine('Xyce'+ timingLine5ValueRegex, aLine, 'Xyce', timingLine1ProcCols, statsFound):
        continue 
      if checkForMulitDataInLine('Analysis'+ timingLine5ValueRegex, aLine, 'Analysis', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Transient'+ timingLine5ValueRegex, aLine, 'Transient', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Nonlinear Solve'+ timingLine5ValueRegex, aLine, 'NonlinearSolve', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Residual'+ timingLine5ValueRegex, aLine, 'Residual', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Jacobian'+ timingLine5ValueRegex, aLine, 'Jacobian', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Successful Step'+ timingLine5ValueRegex, aLine, 'SuccessfulStep',timingLine1ProcCols, statsFound):
        continue  
      if checkForMulitDataInLine('Failed Steps'+ timingLine5ValueRegex, aLine, 'FailedSteps', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Netlist Import'+ timingLine5ValueRegex, aLine, 'NetlistImport', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Parse Context'+ timingLine5ValueRegex, aLine, 'ParseContext', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Distribute Devices'+ timingLine5ValueRegex, aLine, 'DistributeDevices',  timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Verify Devices'+ timingLine5ValueRegex, aLine, 'VerifyDevices', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Instantiate'+ timingLine5ValueRegex, aLine,'Instantiate', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Late Initialization'+ timingLine5ValueRegex, aLine,'LateInitialization', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Global Indices'+ timingLine5ValueRegex, aLine, 'GlobalIndices', timingLine1ProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Setup Matrix Structure'+ timingLine5ValueRegex, aLine, 'SetupMatrixStructure', timingLine1ProcCols, statsFound):
        continue    
    elif prefix == 'TSP':
      if checkForMulitDataInLine('Xyce'+ timingLine13ValueRegex, aLine, 'Xyce', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Analysis'+ timingLine13ValueRegex, aLine, 'Analysis', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Transient'+ timingLine13ValueRegex, aLine, 'Transient', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Nonlinear Solve'+ timingLine13ValueRegex, aLine, 'NonlinearSolve', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Residual'+ timingLine13ValueRegex, aLine, 'Residual', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Jacobian'+ timingLine13ValueRegex, aLine, 'Jacobian', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Successful Step'+ timingLine13ValueRegex, aLine,'SuccessfulStep', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Failed Steps'+ timingLine13ValueRegex, aLine, 'FailedSteps', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Netlist Import'+ timingLine13ValueRegex, aLine, 'NetlistImport', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Parse Context'+ timingLine13ValueRegex, aLine, 'ParseContext', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Distribute Devices'+ timingLine13ValueRegex, aLine, 'DistributeDevices', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Verify Devices'+ timingLine13ValueRegex, aLine, 'VerifyDevices', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Instantiate'+ timingLine13ValueRegex, aLine, 'Instantiate', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Late Initialization'+ timingLine13ValueRegex, aLine, 'LateInitialization', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Global Indices'+ timingLine13ValueRegex, aLine, 'GlobalIndices', timingLineMultiProcCols, statsFound):
        continue
      if checkForMulitDataInLine('Setup Matrix Structure'+ timingLine13ValueRegex, aLine, 'SetupMatrixStructure', timingLineMultiProcCols, statsFound):
        continue
  xyceOutputFile.close()
  
  # clean up stats by 
  # convert any time like HH:MM:SS to just seconds
  # make any "<0.01" into 0.0
  
  for aTag in statsFound.keys():
    # leave the XyceVersion value a string
    if aTag != 'XyceVersion':
      if statsFound[aTag].find('<') >= 0:
        statsFound[aTag] = 0.005
      elif statsFound[aTag].find(':') >= 0:
        #foundFlag = re.search( '\s*([0-9]*)\:?([0-9]*)\:?([0-9]*\.[0-9]*)', statsFound[aTag])
        timeNumbers = re.split(':', statsFound[aTag])
        if( timeNumbers ):
          numTimes = len(timeNumbers)
          # grab the seconds 
          totalTime = float(timeNumbers[numTimes-1])
          # convert the minutes to seconds 
          if numTimes >= 2:
            totalTime += 60*float(timeNumbers[numTimes-2])
          # convert the hours to seconds 
          if numTimes >= 3:
            totalTime += 60*60*float(timeNumbers[numTimes-3])
          # convert the days to seconds 
          if numTimes >= 4:
            totalTime += 24*60*60*float(timeNumbers[numTimes-4])
          statsFound[aTag] = totalTime
      else:
        if re.search('Count', aTag):
          statsFound[aTag] = int(statsFound[aTag])
        elif re.search('Number', aTag):
          statsFound[aTag] = int(statsFound[aTag])
        else:
          statsFound[aTag] = float(statsFound[aTag])
          
  return statsFound
  
def checkForTagInLine(regrex, aLine, keyVal, dictContainer):
  # checks for the regrex passed in.  If it's found then set the key/value in the passed in dictionary. 
  foundFlag = re.search( regrex, aLine)
  if( foundFlag ):
    dictContainer[keyVal] = foundFlag.group(1)
    return True
  return False

def checkForMulitDataInLineOld(regrex, aLine, keyValList, dictContainer):
  # checks for the regrex passed in.  If it's found then set the key/value in the passed in dictionary. 
  foundFlag = re.search( regrex, aLine)
  if( foundFlag ):
    i=1
    for aKey in keyValList:
      dictContainer[aKey] = foundFlag.group(i)
      i=i+1
    return True
  return False

def checkForMulitDataInLine(regrex, aLine, prefix, keyValList, dictContainer):
  # checks for the regrex passed in.  If it's found then set the key/value in the passed in dictionary. 
  foundFlag = re.search( regrex, aLine)
  if( foundFlag ):
    i=1
    for aKey in keyValList:
      newKey = prefix + aKey
      dictContainer[newKey] = foundFlag.group(i)
      i=i+1
    return True
  return False
  
def getPandasTable( fileName, DataColumnLabels=None):
  """ if fileName exists, then load data from it so that new data can be appended.
  if the fileName does not exist then create a blank pandas table with all the data 
  columns we will normally encounter from a parallel run 
  """
  if( os.path.isdir( fileName)):
    print( "Error: Performance data file is a directory  %s" % (fileName))
    return -1
  if( os.path.exists( fileName)):
    df = pandas.read_csv( fileName )
    return df
  df = pandas.DataFrame( columns=DataColumnLabels)
  return df
  
  



#
# if this file is called directly then run the tests
#
if __name__ == '__main__':
  retval = GatherPerformanceData()
  exit( retval)