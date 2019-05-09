#!/usr/bin/env python
from __future__ import print_function
#-------------------------------------------------------------------------------
#
# File: convertXyceFormat.py
#
# Purpose: To quickly plot and/or animate Xyce output files via gnuplot.
#
#          This plotting program suppots Xyce's 3 major text 
#          file formats: std, tecplot, and probe (csd).
#
#          This plotting program even supports .step output.
#       
#          Spice rawfiles (ascii and binary) are also supported.
#          Binary files are architecture specific, so users should only
#          convertXyceFormat binary rawfiles created on the same type of hardware.
#
# Usage:  convertXyceFormat.py [options] foo.cir.prn
#
# Author: Eric Keiter, SNL/NM, Electrical and Microsystems Modeling
#
# Date: $Date$
# Revision: $Revision$
# Owner: $Author$
#-------------------------------------------------------------------------------
"""
This script plots standard Xyce output files
If there are 4 or fewer variables to plot, they will be put in one figure,
otherwise each variable will get its own figure.

Usage:  convertXyceFormat.py [options] foo.cir.prn
options:
  -h or --help                    this display
  -v or --verbose                 print verbose output
  -c or --column                  specify variable to plot
  -i or --indep                   specify the x-axis (independent variable)
  -f or --figures                 put each variable in its own figure
  -o or --outputstd               output standard (default) data file.
  -s or --suppress                don't create plot; read (and write) data.
"""
__author__ = "Eric R. Keiter (erkeite@sandia.gov)"
__version__ = "$Revision$"
__date__ = "$Date$"

#Read:
#Python Essential Reference by Beazley
#

import os, sys, re
import numpy 
import array
import struct
from findBlock import findBlock

import time

#-------------------------------------------------------------------------------
def getXyceData(file,verbose=False):
  """
  getdata(file) reads the data from a Xyce output prn file into a list of
  column names and an array containing the data.
  """
  finished=0
  stepRanges = [0]
  if os.path.exists(file):
    input = open(file,'r').readlines()
    numlines = len(input)-2

    # Check to see if this file is finished file.
    # If it is, the last line will begin with "End"
    s = input[len(input)-1].split()
    if s[0] == 'End':
      finished = 1

    # remove spaces and braces from expressions
    line0 = input[0]
    match = findBlock(line0,delim="\{")
    while match[0]:
      beg = match[0]
      end = match[1]
      group = line0[beg+1:end-1] # remove braces
      line0 = line0[:beg] + re.sub(r"[ ]",r"",group) + line0[end+1:]
      match = findBlock(line0,end,delim="\{")

    tags = line0.split()
    for i in range(len(tags)):
      tmptag = tags[i]
      tmp2=re.sub(r"[ ]",r"",tmptag)
      tags[i] = tmp2

    numentries = len(tags)
    if verbose:
      print ("Read file: " + file)
      print ("Found columns:  ",end=' ')
      print (tags)
      print ("Found " + str(numlines) + " lines of data" )
    data = numpy.zeros((numlines+1,numentries),'double')
    if verbose:
      print ("Reading lines: ",end=' ')
    for i in range(1,len(input)):
      if verbose:
        print (".",end=' ')
      s = input[i].split()
      if s[0] != 'End':  # if this is the final line text string, skip it.
        if len(s) != numentries:
          print ("Error : " + file + ":" + str(i+1))
          print ("Number of columns read is not equal to number of columns in header.")
          print ("numentries = " + str(numentries))
          print ("len(s) = " + str(len(s)))
          print (s)
          sys.exit(1)
        data[i-1,:] = [float(j) for j in s]

    # The ranges will get re-done anyway, so this doesn't have to be 
    # quite right.
    stepRanges.append(numlines)

    if verbose:
      print ("\n")
  else:
    print ("Error, file, " + file + " does not exist")
    print (__doc__)
    sys.exit(1)
  print ("stepRanges = %s" %stepRanges)
  return (tags,data,stepRanges,finished)


#-------------------------------------------------------------------------------
def getXyceRawData(file,verbose=False):
  """
  getXyceRawData(file) reads the data from a Xyce rawfile 
  into a list of column names and an array containing the data.
  """

  stepRanges = [0]
  finished=0
  tags = []

  if os.path.exists(file):
    # FIXME was this file ever closed?
    f = open( file, 'r')
    input = f.readlines(); 


    # process rawfile header ---------------
    # note format of header is:
    #
    # line1: Title
    # line2: Date and Time
    # line3: Plot Title 
    # line4: Flags 
    # line5: Number of Variables
    # line6: Number of Points
    # line7: Version
    # line8: variable List (one variable per line + 1 for "Variables" text) 
    #        format for variable lines are: \t Index \t name \t type \n
    # line8 + num. variables + 1: Data block tagged with Binary if binary or ASCI if ASCI
    #
    # Note: lines 3 through end of data block can be repeated for other data sets
    # or plots.  This code only handles the first one, but there could be more.
    # FIXME Need to handle multiple plot blocks.
       
    # retrieve title
    line = input[0]
    fields = line.split()
    title = line[len(fields[0])+1:len(line)-1]
  
    # retrieve number of variables
    line = input[4]
    fields = line.split()
    numVars = int( fields[2] )

    # retrieve number of data points
    line = input[5]
    fields = line.split()
    numPoints = int( fields[2] )

    # retrieve labels 
    for i in range( 0, numVars ):
      # variable names begin on line 7
      line = input[8 + i]                 

      # split on tab to preserve expressions
      fields = line.split('\t')           

      # remove surrounding whitespace and curly braces from expressions
      tags.append( fields[2].strip('{} ') )

    # determine rawfile format
    line = input[8+numVars]
    fields = line.split()
    isBinary = fields[0] == "Binary:"

    
    # process data points ------------------

    # verbose = True   # FIXME  DEBUGGING

    if verbose:
      print ("Processing rawfile:  ", file)
      print ("Plotting variables:  ",end=' ')
      print (tags)
      print ("Binary format?  ", isBinary)

    if isBinary:
      # cleanup and reopen file for binary reading
      input = []
      f.close()
      f = open( file, 'rb' )  

      # advance past the header
      for i in range( 0, 9 + numVars ):
        input = f.readline()

      if verbose:
        print ("Data starts at file position:  ", f.tell())
        print ("Reading binary values and storing as: ")
      
      # read from file
      vals = array.array( 'd' )
      vals.fromfile( f, ( numPoints * numVars ) )
    
      # swap byte order; needed on ppc 
      if sys.byteorder == "big":
        print ("WARNING:  changing byte order to big-endian")
        vals.byteswap()

      # convert linear to grid 
      data = numpy.array( vals, 'd' )
      data = numpy.reshape( data, ( numPoints, numVars ) )

      if verbose: 
        print (data)

    else: 
      currentLine = 9 + numVars

      if verbose:
        print ("Data starts at line:  ", currentLine)
        print ("Reading ascii values and storing as: ")

      # prepare the array
      data = numpy.zeros( ( numPoints, numVars ), 'double' )

      # store the values
      for i in range( 0, numPoints ):
        if verbose:
          print (i, end=' ')
        # processing "pointNumber\ttime\n" from each block
        s = input[currentLine].split('\t')    
        data[i,0] = float( s[1] );
        if verbose:
          print (data[i,0],end=' ')
     
        for j in range( 1, numVars ):
          s = input[currentLine + j].split()
          data[i,j] = float( s[0] )
          if verbose: 
            print (float( s[0] ),end=' ')
   
        # advance to next data block
        currentLine = currentLine + numVars + 1 

        if verbose:
          print ("\n")


    # done processing
    f.close()
    finished = 1

  # failed reading input file
  else:
    print ("Error, file, " + file + " does not exist")
    print (__doc__)
    sys.exit(1)

  return ( tags, data, stepRanges, title, finished )


#-------------------------------------------------------------------------------
def getXyceTecplotData(file,verbose=False):
  """
  getdata(file) reads the data from a Xyce tecplot output prn file 
  into a list of column names and an array containing the data.
  """
  finished=1
  tags = []
  stepRanges = [0]
  if os.path.exists(file):
    input = open(file,'r').readlines()
    numlines = len(input)-1

    i=0
    line=input[i]
    match = findBlock(line,delim="\"")
    fields = line.split()
    while match[0] != None:
      fields = line.split()
      if fields[0] != "DATASETAUXDATA" and \
         fields[0] != "ZONE" and \
         fields[0] != "AUXDATA":
        beg = match[0]
        end = match[1]
        tag = line[beg+1:end-1]

        # remove spaces and braces from expressions, if any
        subtag = tag
        submatch = findBlock(subtag,delim="\{")
        while submatch[0]:
          subbeg = submatch[0]
          subend = submatch[1]
          group = subtag[subbeg+1:subend-1] # remove braces
          subtag = subtag[:subbeg]+re.sub(r"[ ]",r"",group)+subtag[subend+1:]
          submatch = findBlock(subtag,subend,delim="\{")

        if fields[0] == "TITLE":
          title=tag
        else:
          tag=re.sub(r"[ ]",r"",subtag)
          tags.append(tag)

      i=i+1
      line=input[i]
      match = findBlock(line,delim="\"")

    linediff=i
    linestart=i
    numlines = len(input)-linediff

    numentries = len(tags)
    if verbose:
      print ("Read file: " + file)
      print ("Found variables:  ",end=' ')
      print (tags)
      print ("linestart = %s" %linestart)
      print ("Found " + str(numlines) + " lines of data" )
      print ("Found " + str(numentries) + " different variables" )

    data = numpy.zeros((numlines,numentries),'double')

    if verbose:
      print ("Reading lines: ",end=' ')

    dataIndex = 0
    for i in range(linestart,len(input)):
      if verbose:
        print (".",end=' ')
      s = input[i].split()
      if s[0] != 'End' and \
         s[0] != 'ZONE' and \
         s[0] != 'AUXDATA':  # if this is not a data line, skip it.
        if len(s) != numentries:
          print ("Error: " + file + ":" + str(i+1))
          print ("Number of columns read is not equal to number of columns in header.")
          print ("numentries = " + str(numentries))
          print ("len(s) = " + str(len(s)))
          print (i,s)
          sys.exit(1)
        data[dataIndex,:] = [float(j) for j in s]
        dataIndex += 1

      if s[0] == 'ZONE' or s[0] == 'End':
        stepRanges.append(dataIndex)
         
    stepRanges.append(dataIndex)

    if verbose:
      print ("\n")
  else:
    print ("Error, file, " + file + " does not exist")
    print (__doc__)
    sys.exit(1)

  print ("stepRanges = %s" %stepRanges)
  return (tags,data,stepRanges,title,finished)

#-------------------------------------------------------------------------------
def getXyceProbeData(file,verbose=False):
  """
  getdata(file) reads the data from a Xyce *csd (probe) output file 
  into a list of column names and an array containing the data.
  """
  finished=0
  tags = []
  data = []
  title="Xyce data"
  metadata = {}
  stepRanges = [0]

  if os.path.exists(file):
    input = open(file,'r').readlines()
    numlines = len(input)

    # Now that we have the entire file, check if it is finished or not.
    # Note: this test for #; which is not an adequate test for .step
    # output files.  There is a #; after each step iteration, so if 
    # the file is read in between ".steps" it will be incorrectly declared
    # finished.  I have tested for this, and it does happen.
    #
    line=input[numlines-1]
    fieldsLast = line.split()
    if fieldsLast[0] == "#;":
      finished=1

    # read in the header
    i=0
    line=input[i]
    fields = line.split("'")
    fields[0]=re.sub(r"[\r\n]",r"",fields[0])
    while fields[0] != "#N":
      line1=input[i]
      line=re.sub(r"[=]",r"",line1)
      fields = line.split("'")
      f=0
      for f in range(len(fields)):
        fields[f]=re.sub(r"[\r\n]",r"",fields[f])
      f=0
      while f < len(fields)-1:
        tmpfield = fields[f].upper()
        tmpfield = re.sub(r"[ ]",r"",tmpfield)
        metadata[tmpfield] = fields[f+1]
        f=f+2
      i=i+1

    tags.append(metadata['SWEEPVAR'])
    title = metadata['SOURCE'] + " version " + metadata['VERSION'] + " output file: " + metadata['TITLE']

    line1=input[i]
    line=re.sub(r"[']",r" ",line1)
    fields = line.split()
    while fields[0] != "#C":
      for f in range(len(fields)):
        tags.append(fields[f])
      i=i+1
      line1=input[i]
      line=re.sub(r"[']",r" ",line1)
      fields = line.split()

    linestart = i
    numentries = len(tags)


#  This hardcodes an assumption that Xyce will output at most 5 data points
#  per line in a probe csd format.  This was correct on 18 Jul 2013.  If anyone
#  ever changes Xyce to output some other number of data values per line,
#  these two 5s will have to change. 
    lines_per_step=int((numentries-1)/5)+1
    if ( (numentries-1)%5 != 0):
      lines_per_step = lines_per_step+1

    size = (numlines-linestart)/lines_per_step
    data = numpy.zeros((size,numentries),'double')

    if verbose:
      print ("We have "+str(numlines)+" lines, data starts on line "+str(linestart)+"\n")
      print ("  There are "+str(numentries)+" data elements\n")
      print ("  There should be "+str(lines_per_step)+" lines per step.\n")

    # do the data.  
    dataIndex=0
    lineNum=linestart
    while lineNum+1<numlines and dataIndex<size:
      lineX=input[lineNum]
      line=re.sub(r"[:]",r" ",lineX)
      fieldsX = line.split()

      if fieldsX[0] == "#C":
        # x-axis (indep) variable:
        colNum=0
        value = float (fieldsX[1])
        data[dataIndex,colNum] = value

        # y-axis variables:
        lineY=""
        for subline in range(1,lines_per_step):
          lineY = lineY+input[lineNum+subline].rstrip()+" "

        if verbose:
          print ("Line y is \n       ",lineY)

        line=re.sub(r"[:]",r" ",lineY)
        fieldsY = line.split()
        for colNum in range(1,numentries):
          index = 2*colNum-2
          data[dataIndex,colNum] = float (fieldsY[index])
          if colNum != int(fieldsY[index+1]):
            print ("\nError : *CSD file indices not consistent")
            print ("  This is on line number: " + str(lineNum+1))
            print ("  Column number: " + str(index+1))
            sys.exit(1)
        dataIndex = dataIndex+1
      lineNum=lineNum+lines_per_step

      if fieldsX[0] == "#;":
        stepRanges.append(dataIndex)

    # This append could result in a duplicate, but this line needs to
    # be here.  I don't think duplicates in the stepRanges list matter
    # to the final plot.
    stepRanges.append(dataIndex)

  return (tags,data,stepRanges,title,finished)


#-------------------------------------------------------------------------------
def determineFileType(file):

  if os.path.exists(file):
    input = open(file,'r').readlines()
    numlines = len(input)

    line = input[0]
    fields = line.split()

    fields[0] = re.sub(r"[ ]",r"",fields[0])
    filetype="STD" # default

    if fields[0] == "#H":
      filetype="PROBE"
    elif fields[0] == "TITLE":
      filetype="TECPLOT"
    elif fields[0] == "Title:":  # grossly sensitive test
      filetype="RAW"
    else:
      filetype="STD"

  return (filetype)


#-------------------------------------------------------------------------------
def setupIndepVars (datafile,tags,poptions):
  """ 
  Identify the independent variable, and also assemble an
  exclude list.
  """

  # set up independent variable (x-axis) index:
  # Assume that if the "INDEX" variable is there, it should be ignored.
  # Also assume that if "INDEX" is there, the first variable after it should
  # (by default) be the independent variable by default.

  # Finally, if the *prn file has the sub-string "HOMOTOPY", as part of the
  # file name, assume that "time" is to be excluded as well.

  # first set up the default indep:
  exclude= []
  indep=0

  # Find INDEX, if it exists, and exclude.
  for i in range(len(tags)):
    if "INDEX" in tags[i].upper():
      exclude.append(i)
      indep = i+1

  # If this is a homotopy file, also exclude time variable, and reset indep.
  if "HOMOTOPY" in datafile:
    for i in range(len(tags)):
      if "TIME" in tags[i].upper():
        exclude.append(i)
        indep = i+1

  exclude.append(indep)

  # now attempt to reset indep to a user-specified variable, if specified.
  if poptions["indep"]:
    found=0
    indIndex = 0
    tmp = poptions["indep"]
    indepVar = tmp[0]
    for i in range(len(tags)):
      if tags[i] == indepVar:
        indIndex = i
        found=1
    if (not found):
      print ("Error.  Could not find variable:" + indepVar)
      print ("  Using default x-axis variable\n")
    else:
      indep = indIndex

  return (indep, exclude)

#-------------------------------------------------------------------------------
def getStdStepRanges(stepRanges,tags,data,indep,verbose=False):
  """
  Find the step loop ranges for STD format files.  This isn't needed
  for Tecplot and Probe format files, because they contain enough 
  information.
  """

  stepRanges = [0]

  # Find INDEX, if it exists, and exclude.
  found=0
  indexI=-1
  for i in range(len(tags)):
    if "INDEX" in tags[i].upper():
      indexI=i
      found=1

  # Loop over the data of the independent variable, and if it ever
  # restarts, assume that this represents another .STEP iteration.
  #
  # If there is an INDEX, then use it instead of the independent variable,
  # as it will reliably "restart" at the beginning of each .STEP iteration.
  #
  size = numpy.size(data[:,indep])

  useIndex = indexI
  if found==0:
    useIndex = indep

  for i in range(size-1):
    if data[i+1,useIndex] < data[i,useIndex]:
      stepRanges.append(i+1)

  if len(stepRanges) < 2:
    stepRanges.append(size)

  if verbose:
    print ("In getStdStepRanges.   stepRanges = %s" %stepRanges)
    print ("In getStdStepRanges.   size = " + str(size))
    print ("In getStdStepRanges.   len(stepRanges) = " + str(len(stepRanges)))

  return stepRanges


#-------------------------------------------------------------------------------
def outputStdDataFile(file,tags,data,stepRanges,verbose=False):
  """ This function takes the contents of tags and data, and outputs them
      to a std format *prn file.  This is for testing purposes.
  """

  filename = "test_" + file

  print ("\nCreating std format output file: " + filename )

  output = open(filename,'w')

  tagstring = "Index    "
  numvars = len(tags)
  for i in range(numvars):
    tagstring += tags[i] + "    "
  tagstring += "\n"

  output.write(tagstring)


  sizeStepRanges = len(stepRanges)
  size = stepRanges[sizeStepRanges-1]

  if verbose:
    print ("In outputStdDataFile.   size = ", size)

  for istepRange in range( 0, sizeStepRanges-1):
    indexCount=0
    i = stepRanges[istepRange]
    while i != stepRanges[istepRange+1]:
      numberstring = str(indexCount) + "   "
      indexCount=indexCount+1
      for j in range(0, numvars):
        numberstring += "%12.8e   "%data[i,j] 
      numberstring += "\n"
      output.write(numberstring)
      i=i+1

  finalstring = "End of Xyce(TM) Simulation\n"
  output.write(finalstring)
  return

#-------------------------------------------------------------------------------
from getopt import getopt
def main():
  poptions = { "plotopts":[], 
               "verbose":False, 
               "x11":False, 
               "ps":False, 
               "outputstd":False,
               "suppress":False,
               "animate":False,
               "indep":[],  
               "column":[], 
               "figures":0 }

  progDir,progName = os.path.split(sys.argv[0])
  options = "hvtosaic:p:f"
  long_options = ["help",
                  "verbose", 
                  "x11", 
                  "ps", 
                  "outputstd",
                  "suppress",
                  "animate",
                  "indep=", 
                  "column=",
                  "plot=",
                  "figures"]
  try:
    opts,args = getopt(sys.argv[1:],options,long_options)
  except:
    print ("Unrecognized argument")
    print (__doc__)
    sys.exit(1)

  for flag in opts:
    if flag[0] in ("-h","--help"):
      print (__doc__)
      sys.exit()
    elif flag[0] in ("-p","--plot"):
      poptions["plotopts"].append(flag[1])
    elif flag[0] in ("-v","--verbose"):
      poptions["verbose"] = True
    elif flag[0] in ("-c","--column"):
      poptions["column"].append(flag[1])
    elif flag[0] in ("-i","--indep"):
      poptions["indep"].append(flag[1])
    elif flag[0] in ("-o","--outputstd"):
      poptions["outputstd"] = True
    elif flag[0] in ("-s","--suppress"):
      poptions["suppress"] = True
    elif flag[0] in ("-a","--animate"):
      poptions["animate"] = True
    elif flag[0] in ("--ps"):
      poptions["ps"] = True
    elif flag[0] in ("--x11"):
      poptions["x11"] = True
    elif flag[0] in ("-f","--figures"):
      poptions["figures"] = 1
    else:
      print ("Unrecognized flag:", flag[0])
      print (__doc__)
      sys.exit(1)
  if len(args)==0:
    print ("No prn file specified")
    print (__doc__)
    sys.exit(1)

  datafile = args[0]
  finished=0;
  filetype = determineFileType(datafile)

  title=datafile
  if filetype=="TECPLOT":
    tags,data,stepRanges,title,finished = \
        getXyceTecplotData(datafile,poptions["verbose"])
  elif filetype=="PROBE":
    tags,data,stepRanges,title,finished = \
        getXyceProbeData(datafile,poptions["verbose"])
  elif filetype=="RAW":
    tags,data,stepRanges,title,finished = \
        getXyceRawData(datafile,poptions["verbose"])
  else:
    tags,data,stepRanges,finished = \
        getXyceData(datafile,poptions["verbose"])

  indep,exclude = setupIndepVars (datafile,tags,poptions)

  # If this is a STD or RAW format file, then we need to do extra work
  # to determine the step-loop ranges, if any.  Std files don't
  # include any extra information about .STEP iterations, but
  # tecplot and probe format do.
  if filetype=="STD" or filetype == "RAW":
    stepRanges = getStdStepRanges(stepRanges,tags,data,indep,poptions["verbose"])

  if poptions["suppress"]:
    print ("Suppressed Plot")

  if poptions["outputstd"]:
    outputStdDataFile(datafile,tags,data,stepRanges, poptions["verbose"])

if __name__ == "__main__":
  main()

