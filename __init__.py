#import Shadow.ShadowLib as ShadowLib

try:
  import Shadow.ShadowSrw as ShadowSrw
except ImportError:
  print "h5py not present"
  pass
try:
  import Shadow.ShadowTools as ShadowTools
except ImportError:
  print "matplotlib not present"
  pass
try:
  import Shadow.ShadowPreprocessorsXraylib as ShadowPreprocessorsXraylib
except ImportError:
  print "xraylib not present"
  pass
from Shadow.ShadowMain import *
#TODO
#import ShadowLib 
#from Shadow.ShadowMain import wstd, Beam, geometricSource

