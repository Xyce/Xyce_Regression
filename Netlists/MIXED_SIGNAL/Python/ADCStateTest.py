# This netlist is used to test the getTimeStatePairsADC() 
# method for valid YADC names.  It also tests that the width 
# value on the instance line takes precedence over the width 
# value in the model card, as set by the device models.  It
# also tests the setting of the quantization levels works
# correctly in the constructor for the YADC device.

import sys
# file will be used to compare timeArray and stateArray against
# a gold standard
f= open("ADCStateTest.cir.TSarrayData","w+")

from xyce_interface import xyce_interface

# this calls the xyce_interface.open() method to
# make a xyce object

libDirectory = sys.argv[1]
xyceObj = xyce_interface(libdir=libDirectory)
print( xyceObj )

argv= ['ADCStateTest.cir']
print( "calling initialize with netlist %s" % argv[0] )

result = xyceObj.initialize(argv)
print( "return value from initialize is %d" % result )

# get ADC names;
(result, names) = xyceObj.getDeviceNames("YADC")
print( "return value from getDeviceNames is %d" % result )
print( names )

# get the ADC widths.  This is hard-coded for two ADCs.  The ordering in
# widths seems reversed but names came back as:
#   ['YADC!ADC2', 'YADC!ADC1']
widths=[3,2]
(result,widths) = xyceObj.getADCWidths(names)
print( "return value from getADCWidths is %d" % result )
print( widths )

stepSize = 1e-5
steps = range(0,10)
for i in steps:
  requested_time = 0.0 + (i+1) * stepSize
  print( "Calling simulateUntil for requested_time = %.5f" % requested_time )
  actual_time = 0.0
  (result, actual_time) = xyceObj.simulateUntil( requested_time )
  print( "simulateUntil status = %d and actual_time = %.5f" % (result, actual_time) )
  (result, ADCnames, numADCnames, numPoints, timeArray, stateArray) = xyceObj.getTimeStatePairsADC()
  print( "return value from getTimeStatePairsADC is %d" % result )
  print( "number of ADC names returned by getTimeStatePairsADC is %d" % numADCnames )
  print( ADCnames )
  # output to stdout (for human readability)
  print( "number of points returned by getTimeStatePairsADC is %d" % numPoints )
  print( "ADC 1: Time and state array 0 values are %.3e %d" %(timeArray[0][0] , stateArray[0][0]) )
  print( "ADC 1: Time and state array 0 values are %.3e %d" %(timeArray[0][1] , stateArray[0][1]) )
  print( "ADC 2: Time and state array 0 values are %.3e %d" %(timeArray[1][0] , stateArray[1][0]) )
  print( "ADC 2: Time and state array 1 values are %.3e %d" %(timeArray[1][1] , stateArray[1][1]) )
  # output to file (for comparison against a gold standard)
  f.write( "ADC 1: Time and state array 0 values are %.3e %d\n" %(timeArray[0][0] , stateArray[0][0]) )
  f.write( "ADC 1: Time and state array 1 values are %.3e %d\n" %(timeArray[0][1] , stateArray[0][1]) )
  f.write( "ADC 2: Time and state array 0 values are %.3e %d\n" %(timeArray[1][0] , stateArray[1][0]) )
  f.write( "ADC 2: Time and state array 1 values are %.3e %d\n" %(timeArray[1][1] , stateArray[1][1]) )

print( "calling close")
xyceObj.close()

# close file also
f.close()

