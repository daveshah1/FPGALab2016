# sinegen.py - Generate sinewave table
#  ... for use with Altera ROMs
# Modified by David Shah to generate Xilinx COE files
from math import sin, cos, radians, pi

DEPTH = 1024  # Size of ROM
WIDTH = 10   # Size of data in bits
OUTMAX = 2**WIDTH - 1   # Amplitude of sinewave

filename = "rom_data.coe"
f = open(filename,'w')

#  Header for the .mif file
print >> f, "memory_initialization_radix=16;"
print >> f, "memory_initialization_vector="

for address in range(DEPTH):
	angle = (address*2*pi)/DEPTH
	sine_value = sin(angle)
	data = int((sine_value)*0.5*OUTMAX)+OUTMAX/2
	if address == DEPTH - 1:
		print >> f, "%4x;" % (data)
	else:
		print >> f, "%4x," % (data)
f.close()
