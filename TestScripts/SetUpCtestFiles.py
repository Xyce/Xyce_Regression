#
# this script generates the CMakeLists.txt files in the 
# Xyce_Regression file structure to make regression tests
# available via ctest.

import os.path
import os
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
  parser.add_argument("-v", "--verbose", help="verbose output", action="store_true")
  # get the command line arguments
  args = parser.parse_args()

  # check if Xyce_Regression exists as an input directory.
  if args.verbose:
    print("Looking for Xyce_Regression directory.")
    
  XyceRegressionDirectory = args.input
  if( not os.path.exists( XyceRegressionDirectory)):
    print( "Error: Input Xyce_Regression directory does not exist %s" % (XyceRegressionDirectory))
    return -1
  if( not os.path.isdir( XyceRegressionDirectory)):
    print( "Error: Input Xyce_Regression is not a directory  %s" % (XyceRegressionDirectory))
    return -1
   
  XyceSandiaRegressionDirectory = XyceRegressionDirectory.replace("_Regression", "_SandiaRegression")
  if( not os.path.exists( XyceSandiaRegressionDirectory)):
    print( "Error: Input Xyce_SandiaRegression directory does not exist %s" % (XyceSandiaRegressionDirectory))
    XyceSandiaRegressionDirectory = None
  if( not os.path.isdir( XyceSandiaRegressionDirectory)):
    print( "Error: Input Xyce_SandiaRegression is not a directory  %s" % (XyceSandiaRegressionDirectory))
    XyceSandiaRegressionDirectory = None
  
  XyceFastrackRegressionDirectory = XyceRegressionDirectory.replace("_Regression", "_FastrackRegression")
  if( not os.path.exists( XyceFastrackRegressionDirectory)):
    print( "Error: Input Xyce_FastrackRegression directory does not exist %s" % (XyceFastrackRegressionDirectory))
    XyceFastrackRegressionDirectory = None
  if( not os.path.isdir( XyceFastrackRegressionDirectory)):
    print( "Error: Input Xyce_FastrackRegression is not a directory  %s" % (XyceFastrackRegressionDirectory))
    XyceFastrackRegressionDirectory = None
  
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
        
    #print(depDirectoryDict)
   
  # keep a set of copied Manifest files so we don't copy the same one more then twice 
  copiedManifestDirs = set()
  
  # now loop over keys in the depDirectoryDictionary.  
  # A given key's data will be dependent subdirectories or test cases.
  
  for keyName in depDirectoryDict:
    if args.verbose:
      print( "Working on key", keyName)
    cmakeFileName = os.path.join(keyName, 'CMakeLists.txt')
    fileObj = open( cmakeFileName,'w')
    fileObj.write('# This file is generated by the script SetUpCtestFiles.py\n')
    fileObj.write('# If possible, modify the script to fix any issues with the CMakeLists.txt files\n\n')
    if( keyName == "Xyce_Regression"):
      # make top level CMakeLists.txt file 
      #topLevelCmakeFile = open( os.path.join(XyceRegressionDirectory, 'CMakeLists.txt'), 'w')
      fileObj.write('set(XYCE_VERIFY "${CMAKE_CURRENT_SOURCE_DIR}/TestScripts/xyce_verify.pl")\n')
      fileObj.write('set(OutputDataDir "${CMAKE_CURRENT_SOURCE_DIR}/OutputData")\n')
      fileObj.write('set(TestNamePrefix "")\n')
      fileObj.write('set(XyceRegressionTestScripts ${CMAKE_CURRENT_SOURCE_DIR}/TestScripts)\n')
      fileObj.write('get_target_property(XyceBuildDir Xyce BINARY_DIR)\n')
      fileObj.write('cmake_path(SET XYCE_BINARY $<TARGET_FILE:Xyce>)\n')
      fileObj.write('if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression/CMakeLists.txt" )\n')
      #fileObj.write('  file(REAL_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression" SandiaRegressiontDIR)\n')
      #fileObj.write('  add_subdirectory( ${SandiaRegressiontDIR} Xyce_SandiaRegression)\n')
      fileObj.write('  add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_SandiaRegression Xyce_SandiaRegression)\n')
      fileObj.write('endif()\n')
      fileObj.write('if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression/CMakeLists.txt" )\n')
      #fileObj.write('  file(REAL_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression" FastrackRegressiontDIR)\n')
      fileObj.write('  add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/../Xyce_FastrackRegression Xyce_FastrackRegression)\n')
      fileObj.write('endif()\n')
    
    # Independent test repos have their own output data directories.  Try overriding 
    # the OutputDataDir variable as it should propagate down in scope to test directories 
    if( keyName == "Xyce_SandiaRegression"):
      fileObj.write('set(TestNamePrefix "SandiaTests/")\n')
      fileObj.write('set(OutputDataDir "${CMAKE_CURRENT_SOURCE_DIR}/OutputData")\n')
    if( keyName == "Xyce_FastrackRegression"):
      fileObj.write('set(TestNamePrefix "FastrackTests/")\n')
      fileObj.write('set(OutputDataDir "${CMAKE_CURRENT_SOURCE_DIR}/OutputData")\n')
    for subDirName in depDirectoryDict[keyName]:
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
                  fileObj.write('file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/%s)\n' % (pathForm.parent)) 
                if os.path.exists(os.path.join(keyName,aFile)):
                  fileObj.write('file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/%s ${CMAKE_CURRENT_BINARY_DIR}/%s ONLY_IF_DIFFERENT)\n' % (aFile, aFile))
                  if( aFile.endswith('.pl') or aFile.endswith('.py') or aFile.endswith('.sh')):
                    fileObj.write('file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/%s PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)\n' % (aFile))

          # first run Xyce on the test circuit 
          fileObj.write('add_test(NAME ${TestNamePrefix}%s COMMAND Xyce %s )\n' % (testName, subDirName))
          # write test tags as label for this test
          if( len(testtags) > 0 ):
            fileObj.write('set_property(TEST ${TestNamePrefix}%s PROPERTY LABELS \"%s\")\n' % (testName, testtags))
          # set timelimit option if given as TIMEOUT for ctest 
          if( len(testOptions) > 0):
            for anOpt in testOptions:
              if anOpt[0] == "timelimit":
                fileObj.write('set_tests_properties(${TestNamePrefix}%s PROPERTIES TIMEOUT %s)\n' % (testName, anOpt[1]))
          
          # use the FIXTURES_SETUP and FIXTURES_REQUIRED properties so that testing steps that
          # require the prior steps to pass don't run if it failed.
          fileObj.write('set_tests_properties(${TestNamePrefix}%s PROPERTIES FIXTURES_SETUP %s)\n' % (testName, subDirName))
          
          # now if check if this test needs to generate the gold standard 
          if os.path.exists(os.path.join(keyName, subDirName) + ".prn.gs.pl"):
            fileObj.write('add_test(NAME ${TestNamePrefix}%s.gen_gs COMMAND perl %s.prn.gs.pl )\n' % (testName, subDirName))
            fileObj.write('set_tests_properties(${TestNamePrefix}%s.gen_gs PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
            # now add check the answer against the newly generated gold standard 
            fileObj.write('add_test(NAME ${TestNamePrefix}%s.verify COMMAND ${XYCE_VERIFY} %s %s.prn.gs %s.prn )\n' % (testName, subDirName, subDirName, subDirName))
            fileObj.write('set_tests_properties(${TestNamePrefix}%s.verify PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
          else:
            # look at the path for the test /dirA/dirB/.../Netlists/TestDir1/TestDir2/test.cir 
            # gold standard output will be in ${OutputDataDir}/TestDir1/TestDir2/test.cir.prn
            testPathIndex = keyName.rfind("Netlists")+9
            GoldOutput=os.path.join(keyName[testPathIndex:], subDirName + ".prn")
            fileObj.write('add_test(NAME ${TestNamePrefix}%s.verify COMMAND ${XYCE_VERIFY} %s ${OutputDataDir}/%s %s.prn )\n' % (testName, subDirName, GoldOutput, subDirName))
            fileObj.write('set_tests_properties(${TestNamePrefix}%s.verify PROPERTIES FIXTURES_REQUIRED %s)\n' % (testName, subDirName))
      elif subDirName.endswith(".cir.sh"):
        # look for a test specific tags file.  Load it or the general tags file if the specific one doesn't exist 
        actualFileName = subDirName.removesuffix('.sh')
        testtags=getTags( keyName, actualFileName)
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
                  fileObj.write('file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/%s)\n' % (pathForm.parent)) 
                if os.path.exists(os.path.join(keyName,aFile)):
                  fileObj.write('file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/%s ${CMAKE_CURRENT_BINARY_DIR}/%s ONLY_IF_DIFFERENT)\n' % (aFile, aFile))
                  if( aFile.endswith('.pl') or aFile.endswith('.py') or aFile.endswith('.sh')):
                    fileObj.write('file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/%s PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)\n' % (aFile))
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
          # shell scripts take a standard set of inputs:
          # The input arguments to this script are: 
          # $ARGV[0] = location of Xyce binary
          # $ARGV[1] = location of xyce_verify.pl script
          # $ARGV[2] = location of compare script  -- no scripts use this but it's still passed in 
          # $ARGV[3] = location of circuit file to test
          # $ARGV[4] = location of gold standard prn file
          fileObj.write('add_test(NAME ${TestNamePrefix}%s COMMAND %s %s $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} %s ${OutputDataDir}/%s )\n' % (testName, interpreter, subDirName, actualFileName, GoldOutput))
          # write test tags as label for this test
          if( len(testtags) > 0 ):
            fileObj.write('set_property(TEST ${TestNamePrefix}%s PROPERTY LABELS \"%s\")\n' % (testName, testtags))
          # set timelimit option if given as TIMEOUT for ctest 
          if( len(testOptions) > 0):
            for anOpt in testOptions:
              if anOpt[0] == "timelimit":
                fileObj.write('set_tests_properties(${TestNamePrefix}%s PROPERTIES TIMEOUT %s)\n' % (testName, anOpt[1]))
          
      else:
        # this entry is a sub directory so just add it as such
        # unless it's SandiaTests or FastrackTests.  Then put it in a conditional
        if( subDirName == "SandiaTests" or subDirName == "FastrackTests"):
          fileObj.write('if( EXISTS %s)\n' % (subDirName))
          fileObj.write('    add_subdirectory(%s)\n' % (subDirName))
          fileObj.write('endif ()\n')
        else:
          fileObj.write('add_subdirectory(%s)\n' % (subDirName))
    
    fileObj.close()


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
        #print(exFileData)
        exFile.close()
        if aTestFilePath.name in exFileData:
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
      if (len(newTags) > 0) and (len(testtags)==0):
        testtags = newTags
      elif (len(newTags) > 0):
        testtags = testtags + ";" + newTags
  return testtags
  
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
  
#
# if this file is called directly then run the tests
#
if __name__ == '__main__':
  retval = SetUpCtestFiles()
  exit( retval)
