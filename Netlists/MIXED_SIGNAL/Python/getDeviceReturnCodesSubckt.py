# This netlist is used to test the return codes for the 
# Python methods getDeviceNames() and getDACDeviceNames()
# for the cases of devices in subcircuits:
#   
#    1) Success (1) for a valid non-Y device type (L)
#       that exists in the netlist.
#       
#    2) Success for a valid Y device types (e.g. YADC
#       and YDAC) that exist in the netlist.  This also
#       tests that just DAC works for a Y device.
#
#    3) Success for a valid U device type (e.g. BUF) that 
#       exists in the netlist.
import sys
from xyce_interface import xyce_interface

# this calls the xyce_interface.open() method to
# make a xyce object

libDirectory = sys.argv[1]
xyceObj = xyce_interface(libdir=libDirectory)
print( xyceObj )

argv= ['-quiet','getDeviceReturnCodesSubckt.cir']
print( "calling initialize with netlist %s" % argv[1] )

result = xyceObj.initialize(argv)
print( "return value from initialize is %d" % result )

print( "Calling runSimulation..." )
result = xyceObj.runSimulation()
print( "return value from runSimulation is %d" % result )

# call should succeed since the netlist does have an L device (inductor)
(result, names) = xyceObj.getDeviceNames("L")
print( "return value from getDeviceNames for L model group is %d" % result )
print( names )

(result, names) = xyceObj.getDeviceNames("YADC")
print( "return value from getDeviceNames for YADC model group is %d" % result )
print( names )

# This call should work without the "Y" in the modelGroupName
(result, names) = xyceObj.getDeviceNames("DAC")
print( "return value from getDeviceNames for YDAC model group is %d" % result )
print( names )

(result, names) = xyceObj.getDACDeviceNames()
print( "return value from getDACDeviceNames for YDAC model group is %d" % result )
print( names )

(result, names) = xyceObj.getDeviceNames("BUF")
print( "return value from getDeviceNames for BUF model group is %d" % result )
print( names )

print( "calling close")
xyceObj.close()

