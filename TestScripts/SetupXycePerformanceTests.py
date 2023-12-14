
# A python script that sets up all tests with a performance to be run 
# either as a queued job on a scheduler or as a batch file on a workstation.
# This script doesn't run the jobs but just sets things up to run.
#
# A second script gathers the resulting data and submits it to a storage server.

import os.path
import argparse
from pathlib import Path
import glob
import shutil
import re


def SetUpPerformanceTest():
  """ Set up a directory with tests that have the performance tag and create run script.
  
  This function copies all tests that have the tag 'performance' into an output directory
  where they can be run.  It also generates the batch file that is submitted when running
  the jobs on a computer with a queue submission system and a script to run the tests
  sequentially on a local computer.
  
  Arguments:
    --output <directory where test inputs and outputs will reside>
      Defaults to XycePerformanceOutput if not specified.
    --input <top level Xyce_Regression directory that will be used
      Defaults to Xyce_Regression in the local directory if it exists.
    --mpicommand <mpiexec command to be used if jobs will be run in parallel.>
      Defaults to serial runs if not specified.
    --xyce <Xyce binary to be used>
      Defaults to Xyce if not specififed.
    --tags <Tags to use in test selection. Defautls to just +performance>
    -v, --verbose  Generate verbose output.
    
  """
  # load up argument parser with data
  parser = argparse.ArgumentParser()
  parser.add_argument("--output", help="Directory where test inputs and outputs will reside.", default="XycePerformanceOutput")
  parser.add_argument("--input", help="Top level Xyce_Regression directory that will be used.", default="Xyce_Regression")
  parser.add_argument("--mpicommand", help="Mpiexec command to be used if jobs will be run in parallel.", default="")
  parser.add_argument("--xyce", help="Xyce executable to be used.", default="Xyce")
  parser.add_argument("--tags", help="Tags to use in test selection. +required, -forbidden, ?optional", default="+performance")
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
    
  # get the output directory
  XycePerformanceOutput = args.output
  if args.verbose:
    print("Sending output to %s" % (XycePerformanceOutput))
  
  # get a list of tests with performance tag 
  tagList=args.tags.split(',')
  requiredTags, optionalTags, forbiddenTags = parseSuppliedTagList(tagList)
  if args.verbose:
    print( "From an input tag list of: %s" % (args.tags))
    print( "Required tags are: ", requiredTags)
    print( "Optional tags are: ", optionalTags)
    print( "Forbidden tags are: ", forbiddenTags)
    
  # the glob function used in getTestsInDirectory() doesn't follow sym-links
  # so call it 2 extra times for the two symlinked directories.
  XyceNetlistsDirectory = os.path.join(XyceRegressionDirectory, 'Netlists')
  testList = getTestsInDirectory(XyceNetlistsDirectory, requiredTags, optionalTags, forbiddenTags)
  
  XyceNetlistsDirectory = os.path.join(XyceRegressionDirectory, 'Netlists/SandiaTests')
  testList2 = getTestsInDirectory(XyceNetlistsDirectory, requiredTags, optionalTags, forbiddenTags)
  testList.extend(testList2)
  
  XyceNetlistsDirectory = os.path.join(XyceRegressionDirectory, 'Netlists/FastrackTests')
  testList2 = getTestsInDirectory(XyceNetlistsDirectory, requiredTags, optionalTags, forbiddenTags)
  testList.extend(testList2)
  
  if args.verbose:
    print("Found %d tests" %(len(testList)))
  
  # use a list of files copied to keep the copyTestFiles() function from 
  # doing extra work recopying directories that have multiple tag files and tests
  FilesCopied = []
  for aTestDir, aTagFileName, optionsDict in testList:
    if( str(aTestDir) not in FilesCopied):
      if args.verbose:
        print("Copying %s to %s" % (aTestDir, XycePerformanceOutput))
      FilesCopied.append( str(aTestDir))
      copyTestFiles(aTestDir, aTagFileName, XycePerformanceOutput)


  testCommands = []
  
  submitScriptHeader = """#!/bin/bash
#SBATCH --account=%s
#SBATCH --job-name %s
#SBATCH --time=%d:%d:00
#SBATCH -N %d # number of nodes
#SBATCH --tasks-per-node=%d
#SBATCH -p batch
"""
  sBatchBaseName = 'XyceSBatch'
  sBatchAccount = 'FY200136'
  sBatchJobName = 'FastP'
  sBatchBaseTimeHr = 2
  sBatchBaseTimeMin = 5
  sBatchBaseNodes = 1
  sBatchTaskPerNode = 2
  fastTestsRunCommandsFile = open(sBatchBaseName+'Fast', 'w')
  # set up header for fast tests to allocate 2 hours of total runtime 
  fastTestsRunCommandsFile.write(submitScriptHeader % (sBatchAccount, sBatchJobName, sBatchBaseTimeHr, sBatchBaseTimeMin, sBatchBaseNodes, sBatchTaskPerNode) )
  for aTestDir, aTagFileName, optionsDict in testList:
    # generate the test directory name 
    dirAsString = str(aTestDir)
    DestinationDirectory= Path(dirAsString.replace("Xyce_Regression", XycePerformanceOutput, 1))
    
    # figure out the netlist name 
    circuitNames = []
    if aTagFileName != "tags":
      # this tag file name is the test circuit name plus ".tags"  
      circuitNames.append( aTagFileName.replace('.tags', '', 1) )
    else:
      # tag file name is just "tags"  so search the destination directory for the input files 
      circuitFileList = DestinationDirectory.glob('**/*cir')
      for afile in circuitFileList:
        circuitNames.append( afile.name )
   
    for aCircuit in circuitNames:
      runCommand = "(cd " + str(DestinationDirectory)  + " ;" + args.mpicommand + " " + args.xyce + " " + aCircuit + " > " + aCircuit + ".out)\n" 
      if 'timelimit' in optionsDict:
        # this is a long running test that has a timelimit given 
        # use it to set up a separate run file
        sepRunFile = open(sBatchBaseName+aCircuit, 'w')
        runTimeInHours = float(optionsDict['timelimit'])/(60*60)
        runTimeInMin = float(optionsDict['timelimit'])/(60) 
        if( runTimeInMin > 60):
          runTimeInMin = runTimeInMin % 60
        jobName = aCircuit
        sepRunFile.write(submitScriptHeader % (sBatchAccount, jobName, runTimeInHours, runTimeInMin, sBatchBaseNodes, sBatchTaskPerNode) )
        print("Writing test to batch file %s" %(sBatchBaseName+aCircuit))
        sepRunFile.write(runCommand)
        sepRunFile.close()
      else:
        print("Writing test to batch file %s" %(sBatchBaseName+'Fast'))
        fastTestsRunCommandsFile.write(runCommand )    
  #print(testList)
  fastTestsRunCommandsFile.close()


def parseSuppliedTagList(aTagList):
  """
  given a list of tags "+a", "-b", "?c"
  return the tags separated into required "+" prefix
  forbiden "-" prefix and optional "?" prefix
  """
  requiredTags = []
  optionalTags = []
  forbiddenTags = []
  for atag in aTagList:
    atag = atag.strip()
    if atag.startswith('+'):
      requiredTags.append(atag.strip('+'))
    elif atag.startswith('?'):
      optionalTags.append(atag.strip('?'))
    elif atag.startswith('-'):
      forbiddenTags.append(atag.strip('-'))
    else:
      requiredTags.append(atag)
  return requiredTags, optionalTags, forbiddenTags
    
def getTestsInDirectory( topDir, requiredTags, optionalTags, forbiddenTags ):
  """
  Given a top level directory,and lists of required, optional and forbidden tags
  traverse all sub directories looking for tag files that qualify given the lists of tags.
  return tests that meet the tags requirements.
  """
  # good to start recursive directory search 
  pathObj = Path(topDir)
  # look for any files that match the name "tags" or "<filename>tags"
  tagFileList = glob.glob('*tags', recursive=True)
  #print(tagFileList)
  
  tagFileList = pathObj.glob(os.path.join('**','*tags'))
  #print(tagFileList)
  
  foundFiles = []
  # now we have an iterator for the files, so loop over it 
  for atagFile in tagFileList:
    fullName = os.path.join(atagFile.parent, atagFile.name)
    #print('Examining %s' % (fullName))
    (testTags, testRequiredTags) = getTagsFromFile( fullName )
    meetsRequiredTags = False
    meetsOptionalTags = False
    meetsForbiddentTags = False
    for aTag in requiredTags:
      if aTag in testTags:
        meetsRequiredTags = True
    for aTag in optionalTags:
      if aTag in testRequiredTags:
        meetsOptionalTags = True
    for aTag in forbiddenTags:
      if (aTag in testTags) or (aTag in testRequiredTags):
        meetsForbiddentTags = True
    if( meetsRequiredTags and not meetsForbiddentTags):
      # check for options file that has timelimit or parallel info
      options = getOptionsInfo( atagFile.parent, atagFile.name)
      foundFiles.append( (atagFile.parent, atagFile.name, options))
    
  return foundFiles
      
def getTagsFromFile( filename ):
  """
  Given a filename, return the tags contained in the file as a list
  Any tags prefixed with "required:" are returned in a separate list of
  requiredTags
  """
  # a git repo may have "tags" as a directory name in .git
  if( not os.path.isdir( filename ) ):
    tagFile = open(filename)
    tagsInFile = []
    requiredTagsInFile = []
    for aLine in tagFile:
      if( aLine.startswith('#') == False):
        wordsOnLine = aLine.strip().split(', ')
        for aWord in wordsOnLine:
          requiredTagFound=re.search('required:(\w*)',aWord.strip())
          if( requiredTagFound != None ):
            requiredTagsInFile.append(requiredTagFound.group(1))
          else:
            tagsInFile.append(aWord.strip())
    tagFile.close()
    return tagsInFile, requiredTagsInFile
  return [],[]

def getOptionsInfo( aDir, aTagFile ):
  """
  Given a tag file 'tags' or 'cirfile.cir.tags' look for
  a file called 'options' or 'cirfile.cir.options'
  read that file and return names / values as a dictionary
  """
  resultDict = {}
  optionsFileName = 'options'
  if aTagFile != "tags":
    optionsFileName = aTagFile.replace('.tags', '.options', 1)
  fullOptionsFileName = os.path.join(aDir,optionsFileName)
  if os.path.exists(fullOptionsFileName):
    #print("checking options file %s" % (fullOptionsFileName))
    # file exists so open and read in values 
    optionsFile = open(fullOptionsFileName)
    for aLine in optionsFile:
      if( aLine.startswith('#') == False):
        wordsOnLine = re.split('[= ,]+', aLine.strip())
        while len(wordsOnLine) >= 2 :
          keyVal = wordsOnLine.pop(0)
          value = wordsOnLine.pop(0)
          resultDict[keyVal] = value 
  return resultDict

def copyTestFiles(aTestDir, aTagFileName, aTopLevelDestinationDir):
  """
  Using the Manifest.txt file in each test director, copy over the files needed for a test.
  """
  # make a destination directory with all intermediate directories by just replacing
  # Xyce_Regression in the path name with the top level output directory name passed in 
  dirAsString = str(aTestDir)
  DestinationDirectory= Path(dirAsString.replace("Xyce_Regression", aTopLevelDestinationDir, 1))
  DestinationDirectory.mkdir(parents=True, exist_ok=True)
  
  # open Manifest.txt file 
  manifestFileName = os.path.join( aTestDir, 'Manifest.txt')
  testManifestFile = open( manifestFileName)
  for aLine in testManifestFile:
    filename = aLine.strip()
    filenameWithPath = os.path.join( aTestDir, filename)
    if( os.path.isfile( filenameWithPath )):
      DestinationName = os.path.join( DestinationDirectory, filename )
      shutil.copyfile(filenameWithPath, DestinationName)
  testManifestFile.close()
  return 


#
# if this file is called directly then run the tests
#
if __name__ == '__main__':
  retval = SetUpPerformanceTest()
  exit( retval)
