# This file is used to test the Python getDeviceNames(),
# getDACDeviceNames(), updateTimeVoltagePairs() and 
# obtainResponse() methods
import sys
from xyce_interface import xyce_interface

# this calls the xyce_interface.open() method to
# make a xyce object

libDirectory = sys.argv[1]
xyceObj = xyce_interface(libdir=libDirectory)
print( xyceObj )

argv= ['runCircuitWithDACs.cir']
print( "calling initialize with netlist %s" % argv[0] )

result = xyceObj.initialize(argv)
print( "return value from initialize is %d" % result )

# get ADC and DAC names;
(result, names) = xyceObj.getDeviceNames("YADC")
print( "return value from getDeviceNames is %d" % result )
print( names )

(result, DACnames) = xyceObj.getDACDeviceNames()
print( "return value from getDACDeviceNames is %d" % result )
print( DACnames )

if( len(DACnames) == 0):
  # no names retuned.  This is an error so quit now
  print("ERROR no DAC names returned.  ")
  xyceObj.close()
  exit( -1)
  
if( DACnames[0] != 'YDAC!DAC_DRIVER1'):
  # incorrect name was returned.  This is an error so quit now
  print("ERROR Incorrect DAC name returned.  ")
  print( DACnames[0] )
  xyceObj.close()
  exit( -1)
  

#
# A bug in the DAC device (put there for Habinero support) only takes
# the last time in the time voltage pairs list if the current sim time is 0.
# So simulate a bit first.
requested_time = 1.0e-10
(result, actual_time) = xyceObj.simulateUntil( requested_time )
print( "simulationUntil status = %d and actual_time = %f" % (result, actual_time) )

# try setting up the DAC to pulse twice
timeArrayBase = [ 0.0, 0.1e-4, 0.2e-4, 0.4e-4, 0.5e-4, 0.7e-4, 0.8e-4, 1.0e-4, 1.1e-4 ]
timeArray = timeArrayBase[:]
voltageArray= [ 0.0, 0.0,    3.0,    3.0,    0.0,    0.0,    3.0,    3.0,    0.0    ] 

steps = range(0,10)
total_sim_time = 20.0e-4
for i in steps:
  result = xyceObj.updateTimeVoltagePairs( DACnames[0], timeArray, voltageArray )
  requested_time = 0.0 + (i+1) * 0.1 * total_sim_time
  print( "Calling simulateUntil for requested_time %f" % requested_time )
  actual_time = 0.0
  (result, actual_time) = xyceObj.simulateUntil( requested_time )
  print( "simulateUntil status = %d and actual_time = %f" % (result, actual_time) )
  
  # get some result from the circuit.  Use mixed case for the measure name.
  (result,value) = xyceObj.obtainResponse('YMEMRISTORres')
  print( "return value from obtainResponse = %d" % result)
  print( "R= %f " % value )

  # update timeArray to repeat pulse 
  for j in range(0,len(timeArray)):
    timeArray[j] = timeArrayBase[j] + requested_time
  
print( "calling close")
xyceObj.close()

