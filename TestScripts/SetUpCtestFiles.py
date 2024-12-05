
#
# this script generates the CMakeLists.txt files in the
# Xyce_Regression file structure to make regression tests
# available via ctest.

import os.path
import os
import io
import argparse
from pathlib import Path
from pathlib import PurePath
import glob
import shutil
import re

def SetUpCtestFiles():
  """ Set up the CMakeLists.txt files in Xyce_Regression so tests are useable from ctest

  Decend through all subdirectories and generate CMakeLists.txt files at each level
  so that when Xyce is configured with cmake, regression tests can be added and made
  accessable via ctest.

  Arguments:
    --input <top level Xyce_Regression directory that will be used
      Defaults to Xyce_Regression in the local directory if it exists.
    -v, --verbose  Generate verbose output.

  """
  parser = argparse.ArgumentParser()
  parser.add_argument("--input", help="Top level Xyce_Regression directory that will be used.", default="Xyce_Regression")
  parser.add_argument("--force", help="Force overwrite CMakeLists.txt files", default=False, action="store_true")
  parser.add_argument("--onlydir", help="Only update CMakeLists.txt file for a given directory", default=None)
  parser.add_argument("--dryrun", help="Do not alter any CMakeLists.txt files.", default=False, action="store_true")
  parser.add_argument("--newfile", help="If the CMakeLists.txt file would normally not be overwritten output to CMakeLists.txt.NEW", default=False, action="store_true")
  parser.add_argument("--set-timeouts", help="Use the \"timelimit\" option to set the TIMEOUT property on tests",
                      default=False, action="store_true")
  parser.add_argument("-v", "--verbose", help="verbose output", action="store_true")
  # get the command line arguments
  args = parser.parse_args()

  # check if Xyce_Regression exists as an input directory.
  XyceRegressionDirectory = args.input

  # the script assumes the name has a "_Regression" in it so check for
  # that here in case the user specifies something different, like "."
  if (XyceRegressionDirectory.find("_Regression") < 0):
    print("ERROR: the regression directory must contain the substring \"_Regression\" in it's name")
    return -1

  if( not os.path.exists( XyceRegressionDirectory)):
    print( "Error: Input Xyce_Regression directory does not exist %s" % (XyceRegressionDirectory))
    return -1
  if( not os.path.isdir( XyceRegressionDirectory)):
    print( "Error: Input Xyce_Regression is not a directory  %s" % (XyceRegressionDirectory))
    return -1
  else:
    if args.verbose:
      print("Found regression directory: %s" %(XyceRegressionDirectory))

  # sandia regression directory
  XyceSandiaRegressionDirectory = XyceRegressionDirectory.replace("_Regression", "_SandiaRegression")
  if( not os.path.exists( XyceSandiaRegressionDirectory)):

    # try it as a subdirectory of XyceRegressionDirectory
    XyceTrySandiaRegressionDirectory = XyceRegressionDirectory + "/Xyce_SandiaRegression"
    if( not os.path.exists(XyceTrySandiaRegressionDirectory)):
      print( "Warning: Input Xyce_SandiaRegression directory does not exist %s" % (XyceSandiaRegressionDirectory))
      XyceSandiaRegressionDirectory = None
    else:
      XyceSandiaRegressionDirectory = XyceTrySandiaRegressionDirectory;

  if(XyceSandiaRegressionDirectory != None):
    if( not os.path.isdir( XyceSandiaRegressionDirectory)):
      print( "Warning: Input Xyce_SandiaRegression is not a directory  %s" % (XyceSandiaRegressionDirectory))
      XyceSandiaRegressionDirectory = None
    else:
      if args.verbose:
        print("Found Sandia specific regression directory: %s" %(XyceSandiaRegressionDirectory))

  # fastrack regression directory
  XyceFastrackRegressionDirectory = XyceRegressionDirectory.replace("_Regression", "_FastrackRegression")
  if( not os.path.exists( XyceFastrackRegressionDirectory)):
    # try it as a subdirectory of XyceRegressionDirectory
    XyceTryFastrackRegressionDirectory = XyceRegressionDirectory + "/Xyce_FastrackRegression"
    if( not os.path.exists(XyceTryFastrackRegressionDirectory)):
      print( "Warning: Input Xyce_FastrackRegression directory does not exist %s" % (XyceFastrackRegressionDirectory))
      XyceFastrackRegressionDirectory = None
    else:
      XyceFastrackRegressionDirectory = XyceTryFastrackRegressionDirectory;

  if(XyceFastrackRegressionDirectory != None):
    if( not os.path.isdir( XyceFastrackRegressionDirectory)):
      print( "Warning: Input Xyce_FastrackRegression is not a directory  %s" % (XyceFastrackRegressionDirectory))
      XyceFastrackRegressionDirectory = None
    else:
      if args.verbose:
        print("Found Fastrack specific regression directory: %s" %(XyceFastrackRegressionDirectory))

  # set up symbolic links for directories like Xyce_<Foo>Regression.
  # specifically
  # cd Xyce_Regression/Netlists
  # ln -s ../Xyce_<Foo>Regression/Netlists <Foo>Tests
  # cd Xyce_Regression/OutputData
  # ln -s ../Xyce_<Foo>Regression/OutputData <Foo>Tests
  #setupSimlinks(XyceRegressionDirectory, "Xyce_SandiaRegression", "SandiaTests")
  #setupSimlinks(XyceRegressionDirectory, "Xyce_FastrackRegression", "FastrackTests")

  # the glob function used in getTestsInDirectory() doesn't follow sym-links
  # so call it 2 extra times for the two symlinked directories.
  XyceNetlistsDirectory = os.path.join(XyceRegressionDirectory, 'Netlists')
  testList = getTestsInDirectory(XyceNetlistsDirectory)

  if( XyceSandiaRegressionDirectory != None):
    XyceNetlistsDirectory = os.path.join(XyceSandiaRegressionDirectory, 'Netlists')
    testList2 = getTestsInDirectory(XyceNetlistsDirectory)
    testList.extend(testList2)

  if( XyceFastrackRegressionDirectory != None):
    XyceNetlistsDirectory = os.path.join(XyceFastrackRegressionDirectory, 'Netlists')
    testList2 = getTestsInDirectory(XyceNetlistsDirectory)
    testList.extend(testList2)

  testList.sort()
  if args.verbose:
    print("--------------------")
    for aFile in testList:
      print(aFile)
    print("--------------------")
    print("Found %d tests" %(len(testList)))

  # now make a list of directory to subdirectory maps to aid in making
  # the add_directory() calls to CMake files.
  depDirectoryDict = {}
  for aTest in testList:
    pathObj = Path(aTest)
    parts = pathObj.parts
    #print( aTest)
    #for j in range(0, len(parts)):
    #  print( "==> ", parts[j])

    XyceRegressionNameStart = 0
    for j in range(0, len(parts)):
      if (parts[j] == "Xyce_Regression"):
        XyceRegressionNameStart=j
        break
    keyName = ""
    for j in range(XyceRegressionNameStart, len(parts)-1):
      keyName = os.path.join(keyName,parts[j])
      subDirName = parts[j+1]
      #print("-=-=-> ", keyName, " ", subDirName)
      if keyName in depDirectoryDict:
        depDirectoryDict[keyName].add( subDirName)
      else:
        subDirSet = set()
        subDirSet.add( subDirName)
        depDirectoryDict[keyName] = subDirSet

  # keep a set of copied Manifest files so we don't copy the same one more then twice
  copiedManifestDirs = set()

  # now loop over keys in the depDirectoryDictionary.
  # A given key's data will be dependent subdirectories or test cases.
  filesChanged = 0
  filesGenerated = 0
  for keyName in depDirectoryDict:
    if args.verbose:
      print( "Working on key", keyName)

    if (args.onlydir == None) or (args.onlydir == keyName):
      cmakeFileName = os.path.join(keyName, 'CMakeLists.txt')
      #fileObj = open( cmakeFileName,'w')
      outputBuf = io.StringIO()
      outputBuf.write('# This file is generated by the script SetUpCtestFiles.py\n')
      outputBuf.write('# If possible, modify the script to fix any issues with the CMakeLists.txt files\n')
      outputBuf.write('# Or you can remove this header line to prevent this file from being overwritten\n\n')
      if( keyName == "Xyce_Regression"):
        # make top level CMakeLists.txt file
        #topLevelCmakeFile = open( os.path.join(XyceRegressionDirectory, 'CMakeLists.txt'), 'w')
        outputBuf.write('message(DEBUG "[DBG]: CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")\n')
        outputBuf.write('set(XYCE_VERIFY "${CMAKE_CURRENT_SOURCE_DIR}/TestScripts/xyce_verify.pl")\n')
        outputBuf.write('message(DEBUG "[DBG]: XYCE_VERIFY: ${XYCE_VERIFY}")\n')
        outputBuf.write('set(OutputDataDir "${CMAKE_CURRENT_SOURCE_DIR}/OutputData")\n')
        outputBuf.write('set(TestNamePrefix "")\n')
        outputBuf.write('set(XyceRegressionTestScripts ${CMAKE_CURRENT_SOURCE_DIR}/TestScripts)\n')
        outputBuf.write('get_target_property(XyceBuildDir Xyce BINARY_DIR)\n')
        outputBuf.write('message(DEBUG "[DBG]: XyceBuildDir: ${XyceBuildDir}")\n')
        outputBuf.write('cmake_path(SET XYCE_BINARY $<TARGET_FILE:Xyce>)\n')
        outputBuf.write('message(DEBUG "[DBG]: XYCE_BINARY: ${XYCE_BINARY}")\n')
        outputBuf.write('set(DAKOTA_FOUND FALSE CACHE BOOL "True if dakota found.")\n')
        outputBuf.write('set(PERL_FOUND FALSE CACHE BOOL "True if perl found.")\n')
        outputBuf.write('set(BASH_FOUND FALSE CACHE BOOL "True if bash found.")\n')
        outputBuf.write('set(BASH_FOUND FALSE CACHE BOOL "True if bash found.")\n')
        outputBuf.write('set(BASH_FOUND FALSE CACHE BOOL "True if bash found.")\n')
        outputBuf.write('set(PYTHON_FOUND FALSE CACHE BOOL "True if python package found.")\n')
        outputBuf.write('set(SIMULINK_FOUND FALSE CACHE BOOL "True if simulink found.")\n')
        outputBuf.write('set(XDM_BDL_FOUND FALSE CACHE BOOL "True if xdm_bld found.")\n')
        outputBuf.write('set(MS_VPP_FOUND FALSE CACHE BOOL "True if vpp compiler found.")\n')
        outputBuf.write('set(VALGRIND_FOUND FALSE CACHE BOOL "True if valgrind found.")\n')
        outputBuf.write('set(VALGRIND_MASTER FALSE CACHE BOOL "True if valgrind_master set.")\n')
        outputBuf.write('find_program(PERL_BIN perl)\n')
        outputBuf.write('if( NOT (PERL_BIN STREQUAL "PERL_BIN-NOTFOUND"))\n')
        outputBuf.write('  set(PERL_FOUND "TRUE")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('message(STATUS "Perl found ${PERL_FOUND}")\n')
        outputBuf.write('find_program(BASH_FOUND bash)\n')
        outputBuf.write('if( NOT (BASH_FOUND STREQUAL "BASH_FOUND-NOTFOUND"))\n')
        outputBuf.write('  set(BASH_FOUND "TRUE")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('message(STATUS "Bash found ${BASH_FOUND}")\n')
        outputBuf.write('find_program(PYTHON_BIN python)\n')
        outputBuf.write('if( NOT (PYTHON_BIN STREQUAL "PYTHON_BIN-NOTFOUND"))\n')
        outputBuf.write('  set(PYTHON_FOUND "TRUE")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('message(STATUS "Python found ${PYTHON_FOUND}")\n')
        outputBuf.write('if( PYTHON_FOUND )\n')
        outputBuf.write('  execute_process(COMMAND ${PYTHON_BIN} -c "import numpy" RESULT_VARIABLE CMD_SUCCESS ERROR_QUIET)\n')
        outputBuf.write('  if( CMD_SUCCESS EQUAL 0)\n')
        outputBuf.write('    set(PYTHON_NUMPY_FOUND "TRUE")\n')
        outputBuf.write('  endif()\n')
        outputBuf.write('  message(STATUS "Python package numpy found ${PYTHON_NUMPY_FOUND}")\n')
        outputBuf.write('  execute_process(COMMAND ${PYTHON_BIN} -c "import scipy" RESULT_VARIABLE CMD_SUCCESS ERROR_QUIET)\n')
        outputBuf.write('  if( CMD_SUCCESS EQUAL 0)\n')
        outputBuf.write('    set(PYTHON_SCIPY_FOUND "TRUE")\n')
        outputBuf.write('  endif()\n')
        outputBuf.write('  message(STATUS "Python package scipy found ${PYTHON_SCIPY_FOUND}")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('find_program(XDM_BDL_BIN xdm_bdl)\n')
        outputBuf.write('if( NOT (XDM_BDL_BIN STREQUAL "XDM_BDL_BIN-NOTFOUND"))\n')
        outputBuf.write('  set(XDM_BDL_FOUND "TRUE")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('message(STATUS "xdm_bdl found ${XDM_BDL_FOUND}")\n')
        outputBuf.write('find_program(MS_VPP_BIN vpp)\n')
        outputBuf.write('if( NOT (MS_VPP_BIN STREQUAL "MS_VPP_BIN-NOTFOUND"))\n')
        outputBuf.write('  set(MS_VPP_FOUND "TRUE")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('message(STATUS "vpp found ${MS_VPP_FOUND}")\n')
        outputBuf.write('# Sandia Tests\n')
        outputBuf.write('if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression/CMakeLists.txt" )\n')
        outputBuf.write('  message(STATUS "Adding Xyce_SandiaRegression tests")\n')
        outputBuf.write('  add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression Xyce_SandiaRegression)\n')
        outputBuf.write('elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Xyce_SandiaRegression" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Xyce_SandiaRegression/CMakeLists.txt" )\n')
        outputBuf.write('  message(STATUS "Adding Xyce_SandiaRegression tests")\n')
        outputBuf.write('  add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/Xyce_SandiaRegression Xyce_SandiaRegression)\n')
        outputBuf.write('else()\n')
        outputBuf.write('  message(WARNING "Xyce_SandiaRegression tests not found")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('# Fastrack Tests\n')
        outputBuf.write('if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression/CMakeLists.txt" )\n')
        outputBuf.write('  message(STATUS "Adding Xyce_FasttrackRegression tests")\n')
        outputBuf.write('  add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression Xyce_FastrackRegression)\n')
        outputBuf.write('elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Xyce_FastrackRegression" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Xyce_FastrackRegression/CMakeLists.txt")\n')
        outputBuf.write('  message(STATUS "Adding Xyce_FastrackRegression tests")\n')
        outputBuf.write('  add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/Xyce_FastrackRegression Xyce_FastrackRegression)\n')
        outputBuf.write('else()\n')
        outputBuf.write('  message(WARNING "Xyce_FastrackRegression tests not found")\n')
        outputBuf.write('endif()\n')
        outputBuf.write('# General Tests\n')
        outputBuf.write('message(STATUS "Adding general tests")\n')

      # Independent test repos have their own output data directories.  Try overriding
      # the OutputDataDir variable as it should propagate down in scope to test directories
      if( keyName == "Xyce_SandiaRegression" or keyName == "Xyce_Regression/Xyce_SandiaRegression" ):
        outputBuf.write('set(TestNamePrefix "SandiaTests/")\n')
        outputBuf.write('set(OutputDataDir "${CMAKE_CURRENT_SOURCE_DIR}/OutputData")\n')
      if( keyName == "Xyce_FastrackRegression" or keyName == "Xyce_Regression/Xyce_FastrackRegression" ):
        outputBuf.write('set(TestNamePrefix "FastrackTests/")\n')
        outputBuf.write('set(OutputDataDir "${CMAKE_CURRENT_SOURCE_DIR}/OutputData")\n')

      # sort the values since the order seems to be random and varies
      # from one run to the next otherwise and that causes it to
      # perform changes simply due to order differences in the
      # list. this change fixes that
      myTmpVals = list(depDirectoryDict[keyName])
      myTmpVals.sort()

      for subDirName in myTmpVals:
        # need a unique name for each test even when the same netlist name is used in multiple tests
        # otherwise setting properties on tests gets confused because it keys on test name
        testPathIndex = keyName.rfind("Netlists")+9
        testName=os.path.join(keyName[testPathIndex:], subDirName)

        if subDirName.endswith(".cir"):
          # this entry is a test where Xyce is run on the *.cir file
          # and the output is compared to a gold standard.  The gold standard is either
          # in the OutputDataDir or if there is a file ending in *.cir.prn.gs.pl that is a
          # perl script that generates an analytic gold standard at the time of

          # look for a test specific tags file.  Load it or the general tags file if the specific one doesn't exist
          testtags=getTags( keyName, subDirName)
          (serialConstraint, parallelConstraint) = setConstraintsBasedOnTags( testtags )

          # find out if this is a rad problem so that the verify tests
          # can be skipped in the case of a non-rad build and the rad
          # tests can be set to WILL_FAIL
          radBool = (testtags.find('rad') >= 0)
          radBool = radBool or (testtags.find("required:rad") >= 0)
          radBool = radBool or (testtags.find("required:qaspr") >= 0)

          # look for options set for the test
          testOptions=getOptions(keyName, subDirName)

          if( testtags.find('exclude') < 0):
            # if a test has a tag exclude, then don't include it for now
            # copy files from manafest to local, build directory
            if keyName not in copiedManifestDirs:
              copiedManifestDirs.add(keyName)
              requiredFiles = readFilesFromManifest(keyName)
              for aFile in requiredFiles:
                if (len(aFile) > 0):
                  # need to handled nested sub directories which are needed for some tests. as in sub1/sub2/file
                  pathForm = Path(aFile)
                  #parentsList = pathForm.parents
                  if( len(pathForm.parents) > 1):
                    #dirlist = Path(parentsList[0:len(parentsList)-1])
                    outputBuf.write('file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/%s)\n' % (pathForm.parent))
                  if os.path.exists(os.path.join(keyName,aFile)):
                    outputBuf.write('file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/%s ${CMAKE_CURRENT_BINARY_DIR}/%s ONLY_IF_DIFFERENT)\n' % (aFile, aFile))
                    if( aFile.endswith('.pl') or aFile.endswith('.py') or aFile.endswith('.sh')):
                      outputBuf.write('file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/%s PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)\n' % (aFile))

            # first run Xyce on the test circuit
            if (testtags.find('serial') >= 0):
              outputBuf.write('if( %s )\n' % (serialConstraint))
              outputBuf.write('  add_test(NAME ${TestNamePrefix}%s COMMAND $<TARGET_FILE:Xyce> %s )\n' % (testName, subDirName))
              # write test tags as label for this test
              if( len(testtags) > 0 ):
                outputBuf.write('  set_property(TEST ${TestNamePrefix}%s PROPERTY LABELS \"%s\")\n' % (testName, testtags))

              # add property to allow rad tests to "successfully" fail
              # for a non-rad build
              if (radBool):
                outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES WILL_FAIL $<IF:$<BOOL:${Xyce_RAD_MODELS}>,FALSE,TRUE>)\n' % testName)

              # set rad/norad property and timelimit option, if given, as TIMEOUT for ctest
              if( len(testOptions) > 0):
                for anOpt in testOptions:
                  if(anOpt[0] == "timelimit" and args.set_timeouts):
                    outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES TIMEOUT %s)\n' % (testName, anOpt[1]))

              # use the FIXTURES_SETUP and FIXTURES_REQUIRED properties so that testing steps that
              # require the prior steps to pass don't run if it failed.
              outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES FIXTURES_SETUP %s)\n' % (testName, subDirName))

              # now if check if this test needs to generate the gold standard
              if os.path.exists(os.path.join(keyName, subDirName) + ".prn.gs.pl"):
                outputBuf.write('  add_test(NAME ${TestNamePrefix}%s.gen_gs COMMAND perl %s.prn.gs.pl %s.prn)\n' % (testName, subDirName, subDirName))
                outputBuf.write('  set_tests_properties(${TestNamePrefix}%s.gen_gs PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
                # now add check the answer against the newly generated gold standard
                outputBuf.write('  add_test(NAME ${TestNamePrefix}%s.verify COMMAND ${XYCE_VERIFY} %s %s.prn.gs %s.prn )\n' % (testName, subDirName, subDirName, subDirName))
                outputBuf.write('  set_tests_properties(${TestNamePrefix}%s.verify PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
              else:
                # look at the path for the test /dirA/dirB/.../Netlists/TestDir1/TestDir2/test.cir
                # gold standard output will be in ${OutputDataDir}/TestDir1/TestDir2/test.cir.prn
                testPathIndex = keyName.rfind("Netlists")+9
                GoldOutput=os.path.join(keyName[testPathIndex:], subDirName + ".prn")

                # the verify step only needs to be run if
                # Xyce_RAD_MODELS was ON. this prevents it from being
                # run in the case of a Xyce_RAD_MODELS=OFF build but
                # WILL_FAIL run of the "rad" tests.
                indent = ''
                if (radBool):
                  indent = '  '
                  outputBuf.write('  if (Xyce_RAD_MODELS)\n')
                  
                outputBuf.write('%s  add_test(NAME ${TestNamePrefix}%s.verify COMMAND ${XYCE_VERIFY} %s ${OutputDataDir}/%s %s.prn )\n' % (indent, testName, subDirName, GoldOutput, subDirName))
                outputBuf.write('%s  set_tests_properties(${TestNamePrefix}%s.verify PROPERTIES FIXTURES_REQUIRED %s)\n' % (indent, testName, subDirName))
                if (radBool is True):
                  outputBuf.write('  endif()\n')
                  
              outputBuf.write('endif()\n')
              
            if( testtags.find('parallel') >= 0 ):
              outputBuf.write('if( %s )\n' % (parallelConstraint))
              outputBuf.write('  add_test(NAME ${TestNamePrefix}%s COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> %s )\n' % (testName, subDirName))
              # write test tags as label for this test
              if( len(testtags) > 0 ):
                outputBuf.write('  set_property(TEST ${TestNamePrefix}%s PROPERTY LABELS \"%s\")\n' % (testName, testtags))

              # add property to allow rad tests to "successfully" fail
              # for a non-rad build
              if (radBool):
                outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES WILL_FAIL $<IF:$<BOOL:${Xyce_RAD_MODELS}>,FALSE,TRUE>)\n' % testName)

              # set timelimit option if given as TIMEOUT for ctest
              if( len(testOptions) > 0):
                for anOpt in testOptions:
                  if( anOpt[0] == "timelimit" and args.set_timeouts ):
                    outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES TIMEOUT %s)\n' % (testName, anOpt[1]))

              # use the FIXTURES_SETUP and FIXTURES_REQUIRED properties so that testing steps that
              # require the prior steps to pass don't run if it failed.
              outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES FIXTURES_SETUP %s)\n' % (testName, subDirName))

              # now if check if this test needs to generate the gold standard
              if os.path.exists(os.path.join(keyName, subDirName) + ".prn.gs.pl"):
                outputBuf.write('add_test(NAME ${TestNamePrefix}%s.gen_gs COMMAND perl %s.prn.gs.pl %s.prn)\n' % (testName, subDirName, subDirName))
                outputBuf.write('set_tests_properties(${TestNamePrefix}%s.gen_gs PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
                # now add check the answer against the newly generated gold standard
                outputBuf.write('add_test(NAME ${TestNamePrefix}%s.verify COMMAND ${XYCE_VERIFY} %s %s.prn.gs %s.prn )\n' % (testName, subDirName, subDirName, subDirName))
                outputBuf.write('set_tests_properties(${TestNamePrefix}%s.verify PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
              else:
                # look at the path for the test /dirA/dirB/.../Netlists/TestDir1/TestDir2/test.cir
                # gold standard output will be in ${OutputDataDir}/TestDir1/TestDir2/test.cir.prn
                testPathIndex = keyName.rfind("Netlists")+9
                GoldOutput=os.path.join(keyName[testPathIndex:], subDirName + ".prn")

                # the verify step only needs to be run if
                # Xyce_RAD_MODELS was ON. this prevents it from being
                # run in the case of a Xyce_RAD_MODELS=OFF build but
                # WILL_FAIL run of the "rad" tests.
                indent = ''
                if (radBool):
                  indent = '  '
                  outputBuf.write('  if (Xyce_RAD_MODELS)\n')
                  
                outputBuf.write('%s  add_test(NAME ${TestNamePrefix}%s.verify COMMAND ${XYCE_VERIFY} %s ${OutputDataDir}/%s %s.prn )\n' % (indent, testName, subDirName, GoldOutput, subDirName))
                outputBuf.write('%s  set_tests_properties(${TestNamePrefix}%s.verify PROPERTIES FIXTURES_REQUIRED %s)\n' % (indent, testName, subDirName))
                if (radBool is True):
                  outputBuf.write('  endif()\n')
                  
              outputBuf.write('endif()\n')
        elif subDirName.endswith(".cir.sh"):
          # look for a test specific tags file.  Load it or the general tags file if the specific one doesn't exist
          actualFileName = subDirName.removesuffix('.sh')
          testtags=getTags( keyName, actualFileName)
          (serialConstraint, parallelConstraint) = setConstraintsBasedOnTags( testtags )

          # find out if this is a rad problem so that the verify tests
          # can be skipped in the case of a non-rad build and the rad
          # tests can be set to WILL_FAIL
          radBool = (testtags.find('rad') >= 0)
          radBool = radBool or (testtags.find("required:rad") >= 0)
          radBool = radBool or (testtags.find("required:qaspr") >= 0)

          # look for options set for the test
          testOptions=getOptions(keyName, actualFileName)

          if( testtags.find('exclude') < 0):
            # if a test has a tag exclude, then don't include it for now
            # copy files from manafest to local, build directory
            if keyName not in copiedManifestDirs:
              copiedManifestDirs.add(keyName)
              requiredFiles = readFilesFromManifest(keyName)
              for aFile in requiredFiles:
                if (len(aFile) > 0):
                  # need to handled nested sub directories which are needed for some tests. as in sub1/sub2/file
                  pathForm = Path(aFile)
                  #parentsList = pathForm.parents
                  if( len(pathForm.parents) > 1):
                    #dirlist = Path(parentsList[0:len(parentsList)-1])
                    outputBuf.write('file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/%s)\n' % (pathForm.parent))
                  if os.path.exists(os.path.join(keyName,aFile)):
                    outputBuf.write('file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/%s ${CMAKE_CURRENT_BINARY_DIR}/%s ONLY_IF_DIFFERENT)\n' % (aFile, aFile))
                    if( aFile.endswith('.pl') or aFile.endswith('.py') or aFile.endswith('.sh')):
                      outputBuf.write('file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/%s PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)\n' % (aFile))
            # look at the path for the test /dirA/dirB/.../Netlists/TestDir1/TestDir2/test.cir
            # gold standard output will be in ${OutputDataDir}/TestDir1/TestDir2/test.cir.prn
            testPathIndex = keyName.rfind("Netlists")+9
            GoldOutput=os.path.join(keyName[testPathIndex:], actualFileName + ".prn")

            # in run_xyce_regression, the script file is set to execute with "chmod +x" and then just run
            # From Ctest that doesn't seem to work so need to find out if we call bash or perl on the script file.
            interpreter="bash"
            scriptFile = open(os.path.join(keyName, subDirName), 'r')
            firstLine = scriptFile.readline();
            scriptFile.close()

            if( firstLine.rfind('perl') > 0):
              interpreter="perl -I${XyceRegressionTestScripts}"
              serialConstraint = serialConstraint + " AND PERL_FOUND"
              parallelConstraint = parallelConstraint + " AND PERL_FOUND"
            elif ( firstLine.rfind('python') > 0):
              interpreter="python"
              if( serialConstraint.find("PYTHON") < 0):
                serialConstraint = serialConstraint + " AND PYTHON_FOUND"
              if( parallelConstraint.find("PYTHON") < 0):
                parallelConstraint = parallelConstraint + " AND PYTHON_FOUND"
            elif interpreter == "bash":
              serialConstraint = serialConstraint + " AND BASH_FOUND"
              parallelConstraint = parallelConstraint + " AND BASH_FOUND"

            # shell scripts take a standard set of inputs:
            # The input arguments to this script are:
            # $ARGV[0] = location of Xyce binary
            # $ARGV[1] = location of xyce_verify.pl script
            # $ARGV[2] = location of compare script  -- no scripts use this but it's still passed in
            # $ARGV[3] = location of circuit file to test
            # $ARGV[4] = location of gold standard prn file

            if (testtags.find('serial') >= 0):
              outputBuf.write('if( %s )\n' % (serialConstraint))
              outputBuf.write('  add_test(NAME ${TestNamePrefix}%s COMMAND %s %s $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} %s ${OutputDataDir}/%s )\n' % (testName, interpreter, subDirName, actualFileName, GoldOutput))

              # write test tags as label for this test
              if( len(testtags) > 0 ):
                outputBuf.write('  set_property(TEST ${TestNamePrefix}%s PROPERTY LABELS \"%s\")\n' % (testName, testtags))

              # set rad/norad property and timelimit option, if given, as TIMEOUT for ctest
              if (radBool):
                outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES WILL_FAIL $<IF:$<BOOL:${Xyce_RAD_MODELS}>,FALSE,TRUE>)\n' % testName)

              if( len(testOptions) > 0):
                for anOpt in testOptions:
                  if( anOpt[0] == "timelimit" and args.set_timeouts ):
                    outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES TIMEOUT %s)\n' % (anOpt[1]))
              outputBuf.write('endif()\n')
              
            if( testtags.find('parallel') >= 0 ):
              outputBuf.write('if( %s )\n' % (parallelConstraint))
              outputBuf.write('  add_test(NAME ${TestNamePrefix}%s COMMAND %s %s \"mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>\" ${XYCE_VERIFY} ${XYCE_VERIFY} %s ${OutputDataDir}/%s )\n' % (testName, interpreter, subDirName, actualFileName, GoldOutput))
              # write test tags as label for this test
              if( len(testtags) > 0 ):
                outputBuf.write('  set_property(TEST ${TestNamePrefix}%s PROPERTY LABELS \"%s\")\n' % (testName, testtags))
                
              # set rad/norad property and timelimit option, if given, as TIMEOUT for ctest
              if (radBool):
                outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES WILL_FAIL $<IF:$<BOOL:${Xyce_RAD_MODELS}>,FALSE,TRUE>)\n' % testName)

              if( len(testOptions) > 0):
                for anOpt in testOptions:
                  if( anOpt[0] == "timelimit" and args.set_timeouts ):
                    outputBuf.write('  set_tests_properties(${TestNamePrefix}%s PROPERTIES TIMEOUT %s)\n' % anOpt[1])
              outputBuf.write('endif()\n')
        else:
          # this entry is a sub directory so just add it as such
          # unless it's SandiaTests or FastrackTests.  Then put it in a conditional
          if( subDirName == "SandiaTests" or subDirName == "FastrackTests"):
            outputBuf.write('if( EXISTS %s)\n' % (subDirName))
            outputBuf.write('    add_subdirectory(%s)\n' % (subDirName))
            outputBuf.write('endif ()\n')
          else:
            # this "if" avoids the script adding these subdirectories
            # to Xyce_Regression/CMakeLists.txt when they are within
            # the Xyce_Regression subdirectory
            if( subDirName != "Xyce_SandiaRegression" and subDirName != "Xyce_FastrackRegression"):
              outputBuf.write('add_subdirectory(%s)\n' % (subDirName))

      filesGenerated += 1
      # have the CMakeLists.txt file contents ready.  Check with any existing file if
      # this needs to be written out.
      isChanged = True
      hasAutoHeader = True
      writeFileToDisk = False
      if( os.path.exists(cmakeFileName)):
        fileObj = open( cmakeFileName,'r')
        oldFileData = io.StringIO()
        for aLine in fileObj:
          oldFileData.write(aLine)
        fileObj.close()
        isChanged = newFileDifferentFromOld(outputBuf.getvalue(), oldFileData.getvalue() )
        hasAutoHeader = hasAutoGenHeader(oldFileData.getvalue())
        oldFileData.close()

        # logic to determine when to write the file and when not
        # to.
        if (isChanged and hasAutoHeader):
          # if the new file differs and the standard header is intact
          # write the new file
          writeFileToDisk = True
        elif (isChanged and not hasAutoHeader and args.newfile):
          # if the header has been removed, and the user wants to
          # write a CMakeLists.txt.NEW for comparison
          writeFileToDisk = True
          cmakeFileName = cmakeFileName + ".NEW"
        elif (args.force):
          # if the user wants to overwrite, even files without the
          # standard header always do so when force is specified
          writeFileToDisk = True

        if args.verbose:
          print("%s: newfile = %d, isChanged = %d , hasAutoHeader = %d, writeToFile = %d " % (cmakeFileName, args.newfile, isChanged, hasAutoHeader, writeFileToDisk))

      # if the new file is different
      if( writeFileToDisk ):
        if args.verbose:
          print("Writing %s" % (cmakeFileName))

        if( not args.dryrun):
          filesChanged +=1
          fileObj = open( cmakeFileName,'w')
          fileObj.write(outputBuf.getvalue())
          fileObj.close()
      else:
        if args.verbose:
          print("Skipping %s" % (cmakeFileName))

      outputBuf.close()
  print("%d Files updated of %d files checked." % (filesChanged, filesGenerated))

def setupSimlinks(xyceRegressionDir, regressionDir, shortName):
  # set up symbolic links for directories like Xyce_<Foo>Regression.
  # specifically
  # cd Xyce_Regression/Netlists
  # ln -s ../Xyce_<Foo>Regression/Netlists <Foo>Tests
  # cd Xyce_Regression/OutputData
  # ln -s ../Xyce_<Foo>Regression/OutputData <Foo>Tests
  if( not os.path.exists( os.path.join(xyceRegressionDir, "Netlists", shortName )) and os.path.exists( os.path.join(xyceRegressionDir, "..", regressionDir)) ):
    # make link
    os.symlink(os.path.join("..", "..", regressionDir, "Netlists"), os.path.join(xyceRegressionDir, "Netlists", shortName), target_is_directory=True )
  if( not os.path.exists( os.path.join(xyceRegressionDir, "OutputData", shortName )) and os.path.exists( os.path.join(xyceRegressionDir, "..", regressionDir)) ):
    # make link
    os.symlink(os.path.join("..", "..", regressionDir, "OutputData"), os.path.join(xyceRegressionDir, "OutputData", shortName), target_is_directory=True )

def getTestsInDirectory( topDir ):
  """
  Given a top level directory, traverse all sub directories looking for *cir files
  or *cir.sh or *cir.prn.gs.pl files for test initiation files.  Remove any file from
  consideration for testing that is in the exclude file
  """

  # glob gets all the files at once.  Can be slow and doesn't give a complete path.
  # look for any files that match the form *cir, *cir.sh, *cir.prn.gs.pl
  #testFileList = glob.glob(os.path.join('**','*cir'), root_dir=topDir, recursive=True)
  #print("using glob.glob")
  #print(testFileList)

  # Path makes an interator
  # good to start recursive directory search
  pathObj = Path(topDir)
  testFileListItt = pathObj.glob(os.path.join('**','*cir'))
  #print("using pathObj.glob")
  #print(testFileListItt)

  foundFiles = []
  # now we have an iterator for the files, so loop over it
  for aTestFilePath in testFileListItt:
    if( 'SandiaTests' in aTestFilePath.parents ):
      print( "Skipping SandiaTests location", aTestFilePath)
    else:
      fullName = os.path.join(aTestFilePath.parent, aTestFilePath.name)
      #print('Examining %s' % (fullName))
      inExcludeFile = False
      excludeFile = os.path.join(aTestFilePath.parent, 'exclude')
      if( os.path.exists(excludeFile) and os.path.isfile(excludeFile)):
        #print( "Found exclude file at ", aTestFilePath.parent)
        exFile = open( excludeFile, 'r')
        exFileData = [aLine.strip() for aLine in exFile.readlines()]
        exFile.close()
        exFileData2 = []
        for aLine in exFileData:
          if( aLine.find('#') > 0 ):
            # there is an inline comment here.  Remove it
            aLine=aLine[0:aLine.find('#')].rstrip()
          exFileData2.append(aLine)
        #print(exFileData)
        if aTestFilePath.name in exFileData2:
          #print( "=====> ", aTestFilePath.name, " is in ", excludeFile, " and will be skipped")
          inExcludeFile = True
      # file wasn't excluded. Check if a *.cir.sh file exists that should be called instead.
      fullNameWithSh = fullName + ".sh"
      if( os.path.exists(fullNameWithSh) and os.path.isfile(fullNameWithSh)):
        fullName = fullNameWithSh
      if( not inExcludeFile ):
        foundFiles.append (fullName)

  #  (testTags, testRequiredTags) = getTagsFromFile( fullName )
  #  meetsRequiredTags = False
  #  meetsOptionalTags = False
  #  meetsForbiddentTags = False
  #  for aTag in requiredTags:
  #    if aTag in testTags:
  #      meetsRequiredTags = True
  #  for aTag in optionalTags:
  #    if aTag in testRequiredTags:
  #      meetsOptionalTags = True
  #  for aTag in forbiddenTags:
  #    if (aTag in testTags) or (aTag in testRequiredTags):
  #      meetsForbiddentTags = True
  #  if( meetsRequiredTags and not meetsForbiddentTags):
  #    # check for options file that has timelimit or parallel info
  #    options = getOptionsInfo( atagFile.parent, atagFile.name)
  #    foundFiles.append( (atagFile.parent, atagFile.name, options))

  return foundFiles

def getTags( parentDirName, testFileName):
  # look for a test specific tags file.  Load it or the general tags file if the specific one doesn't exist
  testtags=""
  tagFileData=None
  tagFileName=None
  if os.path.exists((os.path.join(parentDirName, testFileName)+".tags")):
    tagFileName=os.path.join(parentDirName, testFileName)+".tags"
  elif os.path.exists(os.path.join(parentDirName, "tags")):
    tagFileName=os.path.join(parentDirName, "tags")
  # read in the tags
  if tagFileName:
    tagFile = open(tagFileName, 'r')
    tagFileData = [aLine.strip() for aLine in tagFile.readlines()]
    tagFile.close()
  # get them on a single line separated by semicolin
  if tagFileData:
    # combine the tags into one line separated by semicolns
    for tagline in tagFileData:
      newTags = tagline.replace(',',';')
      newTags = newTags.replace(' ', '')
      if (len(newTags) > 0) and (newTags[0] != '#') and (len(testtags)==0):
        testtags = newTags
      elif (len(newTags) > 0) and (newTags[0] != '#'):
        testtags = testtags + ";" + newTags
  return testtags

def setConstraintsBasedOnTags( inputTags ):
  # Build cache variables can be used to predetermine which tags already apply
  # use them to set up a boolean condition statement that can be used around
  # an if() conditional to conditionally include a test.
  #
  # this dictionary connects tags to cache variables
  #   tag                 Cache var
  tagToCacheDict = {
    'required:fft':'Xyce_USE_FFT',
    'required:athena':'Xyce_ATHENA',
    'required:buildplugin':'Xyce_PLUGIN_SUPPORT',
    'required:dakota': 'DEFINED Xyce_Dakota',
    'required:dakota_bb': 'DAKOTA_FOUND',
    'required:rol':'Xyce_ROL',
    'required:amesos2basker':'Xyce_AMESOS2',
    'required:stokhos':'Xyce_STOKHOS_ENABLE',
    'required:simulink': 'SIMULINK_FOUND',
    'required:pymi':'DEFINED Xyce_PYMI',
    'required:nonfree':'Xyce_NONFREE_MODELS',
    'required:verbose':'Xyce_VERBOSE_TIME',
    'required:valgrind': 'VALGRIND_FOUND',
    'required:valgrindmaster': 'VALGRIND_MASTER',
    'required:windows': 'WIN32',
    'required:xdm': 'XDM_BDL_FOUND',
    'required:mixedsignal': 'MS_VPP_FOUND',
    'python':'PYTHON_FOUND',
    'numpy':'PYTHON_NUMPY_FOUND',
    'scipy':'PYTHON_SCIPY_FOUND' }

  # Note WIN32 is a CMake variable that is true under both 32 and 64 bit Windows.

  # note there are several verbose flags.  We may need to AND them all
  # Xyce_VERBOSE_TIME, Xyce_VERBOSE_LINEAR, Xyce_VERBOSE_NONLINEAR, Xyce_VERBOSE_NOX

  serialConditional="(NOT Xyce_PARALLEL_MPI)"
  parallelConditional="Xyce_PARALLEL_MPI "
  inputTagList = inputTags.split(';')
  for aTag in inputTagList:
    if aTag in tagToCacheDict:
      serialConditional = serialConditional + " AND " + tagToCacheDict[aTag]
      parallelConditional = parallelConditional + " AND " + tagToCacheDict[aTag]
        
  return (serialConditional, parallelConditional)

def getOptions( parentDirName, testFileName):
  # look for a test specific options file.  Load it or the general options file if the specific one doesn't exist
  testoptions=[]
  optionsFileData=None
  optionsFileName=None
  if os.path.exists((os.path.join(parentDirName, testFileName)+".options")):
    optionsFileName=os.path.join(parentDirName, testFileName)+".options"
  elif os.path.exists(os.path.join(parentDirName, "options")):
    optionsFileName=os.path.join(parentDirName, "options")
  # read in the options
  if optionsFileName:
    optionsFile = open(optionsFileName, 'r')
    optionsFileData = [aLine.strip() for aLine in optionsFile.readlines()]
    optionsFile.close()
  # get them on a single line separated by semicolin
  if optionsFileData:
    # combine the options into line separated by semicolns
    for optionsline in optionsFileData:
      newOptions = optionsline.split(',')
      for anOpt in newOptions:
        theOpt=anOpt.strip()
        if( theOpt.find('=') > 0 ):
          (optLabel, optVal) = theOpt.split('=')
        testoptions.append( (optLabel, optVal))
  return testoptions

def readFilesFromManifest( dirName ):
  foundFiles = []
  manifestFileName=os.path.join(dirName, 'Manifest.txt')
  if os.path.exists(manifestFileName):
    manifestFile = open(manifestFileName)
    foundFiles = [aLine.strip() for aLine in manifestFile.readlines()]
    manifestFile.close()
  return foundFiles

def newFileDifferentFromOld(strList1, strList2 ):
  # compare the files in outputBuf to oldFileData
  retval = True
  if( len(strList1) != len(strList2)):
    #print( 'Old and new have different lengths %d, %d' % (len(strList1), len(strList2) ))
    #print( strList1 )
    #print( strList2 )
    return retval
  for i in range(0,len(strList1)):
    line1 = strList1[i]
    line2 = strList2[i]
    if( not (line1 == line2)):
      #print( 'Different at %d, "%s", "%s"' % (i, line1, line2))
      #print( strList1 )
      #print( strList2 )
      return retval
  retval = False
  return retval

def hasAutoGenHeader(strList):
  retval = True
  if( strList.find('# Or you can remove this header line to prevent this file from being overwritten') == -1):
    # autogenerated header text is missing so do not overwrite this file
    retval = False
  return retval

#
# if this file is called directly then run the tests
#
if __name__ == '__main__':
  retval = SetUpCtestFiles()
  exit( retval)
