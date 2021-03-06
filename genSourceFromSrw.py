#!/usr/bin/python
import Shadow as sd
import srwlib as sr
import optparse

def foo_callback(option, opt, value, parser):
  setattr(parser.values, option.dest, value.split(','))

if __name__ == '__main__':

  p = optparse.OptionParser()
  helps = {
    'f':'Input file with Stokes parameters, if hdf5 give the entire name, if bin give root name.',
    'o':'Output file for shadow3 rays. default begin.dat',
    'n':'set number of rays to simulate.',
    'm':'set method Multi Electron (ME) or Single Electron (SE).',
    'e':'select one energy or an energy range (two values separated by comma). [eV].',
    'c':'set simulation for canted undulator, value means distance between straight section and center of undulator. [m]',
    'a':'set aperture. If SE is used the aperture of the convoluted distribution might differ from the single electron one, [m],[m]', 
    'd':'set distance if you load stokes from ASCII file. [m]',
    }

  p.add_option('-f', '--infile', dest='infile', metavar='FILE', help=helps['f'])
  p.add_option('-o', '--outfile', dest='outfile', metavar='FILE', default='begin.dat', help=helps['o'])
  p.add_option('-n', '--number', dest='rays', metavar="NUMBER", type="int", help=helps['n'])
  p.add_option('-m', '--method', dest='method', action="store", type="string", default='ME', help=helps['m'])
  p.add_option('-e', '--energy', dest='energy', metavar="NUMBER", type="string", default=None,
      action='callback', callback=foo_callback, help=helps['e'])
  p.add_option('-c', '--canted', dest='canted', metavar="NUMBER", type="float", default=None, help=helps['c'])
  p.add_option('-a', '--aperture', dest='aperture', metavar="NUMBER", type="string", default=None,
      action='callback', callback=foo_callback, help=helps['a'])
  p.add_option('-d', '--distance', dest='distance', metavar="NUMBER", type="float", default=None, help=helps['d'])

  options,args = p.parse_args()

  if options.energy!=None: options.energy = [ float(e) for e in options.energy ]
  if options.aperture!=None: options.aperture = [ float(a) for a in options.aperture ]

  #if options.canted!=None:
  lim = [options.aperture[0],options.aperture[1]]
  #else:
  #  lim=None
  beam,param = sd.ShadowSrw.genShadowBeam(options.infile,options.rays,options.method,energy=options.energy,lim=lim,canted=options.canted,distance=options.distance)
  beam.write(options.outfile)
  sd.ShadowSrw.WriteParameters(options.outfile+".py",param)

