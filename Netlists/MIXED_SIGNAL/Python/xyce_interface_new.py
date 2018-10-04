

# Python wrapper on Xyce via Xyce library mode via ctypes

import sys,traceback,types
#import ctypes 
from ctypes import *
from ctypes.util import *

class xyce_interface:
  def __init__(self,name="",cmdargs=None):
    
    try:
      libName=''
      libName=find_library('xycecinterface')
      print( "libName returned \"", libName, "\"")
      if( libName != None ):
        print("trying to load \"", libName, "\"")
        self.lib = cdll.LoadLibrary(libName)
        #self.lib = CDLL(libName)
        print( self.lib )
      #if not name: self.lib = CDLL(libName,RTLD_GLOBAL)
      else: 
        if not name: 
          print( "In not name branch...") 
          if sys.platform.startswith('darwin'):
            self.lib = CDLL("libxycecinterface.dylib",RTLD_GLOBAL)
          else:
            self.lib = CDLL("libxycecinterface.so",RTLD_GLOBAL)
        else:
          print("In else branch of not-name")
          if sys.platform.startswith('darwin'):
            self.lib = CDLL("libxyce_%.dylib" % name,RTLD_GLOBAL)
          else:
            self.lib = CDLL("libxyce_%.so" % name,RTLD_GLOBAL)
    except:
      type,value,tb = sys.exc_info()
      traceback.print_exception(type,value,tb)
      raise OSError("Could not load libxyce dynamic library")
    if cmdargs:
      self.xycePtr = c_void_p()
      self.lib.xyce_open(byref(self.xycePtr))
    else:
      self.xycePtr = c_void_p()
      self.lib.xyce_open(byref(self.xycePtr))

  def __del__(self):
    if self.xycePtr:
      self.xycePtr = None 
      #self.lib.xyce_close(byref(self.xycePtr))

  def close(self):
    self.lib.xyce_close(byref(self.xycePtr))
    self.xycePtr = None
    
  def initialize(self, args):
    # convert args to a c-array that can be passed to the
    # underlying code
    args.insert(0, "xyce_interface.py")
    narg = len(args)
    # allocate new C array 
    cargs = (c_char_p*narg)()
    # initialize the array
    for i in range(0,narg):
      cargs[i] = args[i].encode('utf-8')
    print( cargs )
    status = self.lib.xyce_initialize( byref(self.xycePtr), narg, cargs )
    return status
    
  def runSimulation( self ):
    status = self.lib.xyce_runSimulation( byref(self.xycePtr) )
    return status
    
  def simulateUntil( self, requestedTime ):
    csimTime = c_double(0)
    status = self.lib.xyce_simulateUntil( byref(self.xycePtr), c_double(requestedTime), byref(csimTime) )
    simulatedTime = csimTime.value
    return (status, simulatedTime )
    
  def getDeviceNames( self, basename ):
    # calling xyce_getDeviceNames(void ** ptr, char * modelGroupName, int & numDevNames, char ** deviceNames)
    cBaseName = c_char_p(basename.encode('utf-8'))
    cNumDeviceNames = c_int( 0 )
    maxNumDevices=1000
    maxDeviceNameLength=1000
    deviceNameBuff = [create_string_buffer(maxDeviceNameLength) for i in range(maxNumDevices)]
    cDeviceNameArray = (c_char_p*maxNumDevices)(*map(addressof, deviceNameBuff))
    #print( cDeviceNameArray )
    status = self.lib.xyce_getDeviceNames( byref(self.xycePtr), cBaseName, byref(cNumDeviceNames), cDeviceNameArray)
    #print( cNumDeviceNames.value, cDeviceNameArray[0],  cDeviceNameArray[1])
    names = []
    for i in range(0, cNumDeviceNames.value):
      names.insert(i, cDeviceNameArray[i] )
    return (status, names)
  
  def getDACDeviceNames( self ):
    cNumDeviceNames = c_int( 0 )
    maxNumDevices=1000
    maxDeviceNameLength=1000
    deviceNameBuff = [create_string_buffer(maxDeviceNameLength) for i in range(maxNumDevices)]
    cDeviceNameArray = (c_char_p*maxNumDevices)(*map(addressof, deviceNameBuff))
    #print( cDeviceNameArray )
    status = self.lib.xyce_getDACDeviceNames( byref(self.xycePtr), byref(cNumDeviceNames), cDeviceNameArray)
    #print( cNumDeviceNames.value, cDeviceNameArray[0],  cDeviceNameArray[1])
    names = []
    for i in range(0, cNumDeviceNames.value):
      names.insert(i, cDeviceNameArray[i] )
    return (status, names)
    return status
  
  def getADCMap( self ):
    status = self.lib.xyce_getADCMap( byref(self.xycePtr) )
    return status
  
  def updateTimeVoltagePairs( self, basename,  time, voltage):
    cBaseName = c_char_p(basename)
    if( len( time ) != len( voltage ) ):
      print( "Time and Voltage arrays passed to updateTimeVoltagePairs are of the same length.")
      return -1
    cNumPts = c_int(len(time))
    cArray = c_double*len(time)
    cTimeArray = (c_double*len(time))(*time)
    cVoltageArray = (c_double*len(time))(*voltage)
      
    status = self.lib.xyce_updateTimeVoltagePairs( byref(self.xycePtr), cBaseName, cNumPts, byref(cTimeArray), byref(cVoltageArray) )
    return status
    
  def checkResponseVarName(self , varName):
    cvarName = c_char_p(varName)
    status = self.lib.xyce_checkResponseVar( byref(self.xycePtr), cvarName )
    return status
    
  def obtainResponse(self, varName):
    cvarName = c_char_p(varName.encode('utf-8'))
    cValue = c_double(0.0)
    status = self.lib.xyce_obtainResponse( byref(self.xycePtr), cvarName, byref(cValue) )
    return (status, (cValue.value))
  
  def getTimeVoltagePairsADC( self ):
    cNumADCnames = c_int(0)
    maxNumDevices=1000
    maxDeviceNameLength=1000
    maxNumTimeVoltagePairs=1000
    ADCDeviceNameBuff = [create_string_buffer(maxDeviceNameLength) for i in range(maxNumDevices)]
    cADCDeviceNameArray = (c_char_p*maxNumDevices)(*map(addressof, ADCDeviceNameBuff))
  
    cNumPoints = (c_int*maxNumDevices)
    cDoubleBuff = (c_double*maxNumTimeVoltagePairs)
    cTimeArray = (c_double*maxNumDevices)(*map(addressof, cDoubleBuff ))
    cVoltageArray = (c_double*maxNumDevices)(*map(addressof, cDoubleBuff))
    
    xyce_getTimeVoltagePairsADC( void** ptr, byref(cNumADCnames), byref(cADCDeviceNameArray), byref(cNumPoints), byref(cTimeArray), byref(cVoltageArray) );
  
    return status
  
  def setADCWidths( self, ADCnames, ADCwidths ):
    # make a char ** structure for ADCnames and an int[] for ADCwidths
    if( len(ADCnames) != len(ADCwidths) ):
      print( "lenghts of ADC names list and widths list must be the same.")
      return -1
    nADCs = len(ADCnames)
    cADCnames = (c_char_p*nADCs)()
    for i in range(0,nADCs):
      cADCnames[i] = ADCnames[i].encode('utf-8')
      
    cADCwidths = (c_int*nADCs)()
    for i in range(0,nADCs):
      cADCwidths[i]=ADCwidths[i].encode('utf-8')
    
    status = self.lib.xyce_setADCWidths( byref(self.xycePtr), nADCs, byref(cADCnames), byref(cADCwidths) )
    return status
    
  

#   def file(self,file):
#     self.lib.spparks_file(self.xycePtr,file)
# 
#   def command(self,cmd):
#     self.lib.spparks_command(self.xycePtr,cmd)
# 
#   def extract(self,name,type):
#     if type == 0:
#       self.lib.spparks_extract.restype = POINTER(c_int)
#       ptr = self.lib.spparks_extract(self.xycePtr,name)
#       return ptr[0]
#     if type == 1:
#       self.lib.spparks_extract.restype = POINTER(c_int)
#       ptr = self.lib.spparks_extract(self.xycePtr,name)
#       return ptr
#     if type == 2:
#       self.lib.spparks_extract.restype = POINTER(POINTER(c_int))
#       ptr = self.lib.spparks_extract(self.xycePtr,name)
#       return ptr
#     if type == 3:
#       self.lib.spparks_extract.restype = POINTER(c_double)
#       ptr = self.lib.spparks_extract(self.xycePtr,name)
#       return ptr[0]
#     if type == 4:
#       self.lib.spparks_extract.restype = POINTER(c_double)
#       ptr = self.lib.spparks_extract(self.xycePtr,name)
#       return ptr
#     if type == 5:
#       self.lib.spparks_extract.restype = POINTER(POINTER(c_double))
#       ptr = self.lib.spparks_extract(self.xycePtr,name)
#       return ptr
#     return None
# 
#   def energy(self):
#     self.lib.spparks_energy.restype = c_double
#     return self.lib.spparks_energy(self.xycePtr)
