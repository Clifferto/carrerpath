import matplotlib.pyplot as plt 
import numpy as np
import PyLTSpice.LTSpice_RawRead as sp
#import PyLTSpice.LTSpiceBatch as ltCommander
from shutil import copyfile
import os

meAbsPath = os.path.dirname(os.path.realpath(__file__))

# lTC = ltCommander.SimCommander("c1AmpDif.asc")

# lTC.set_parameter('V_1',0)
# lTC.set_parameter('V_2',1)

# lTC.add_instructions(
#    "; Simulation settings",
#    ".ac dec 30 .1 100Meg"
# )
# # lTC.reset_netlist()  # This resets all the changes done to the checklist

# lTC.run()

# print(type(lTC.wait_completion()))

##########################################################

LTR = sp.LTSpiceRawRead("c1AmpDif.raw") 

print(LTR.get_trace_names())
# print(LTR.get_raw_property())

# Recuperar graficas
trace = LTR.get_trace("V(vo1)")

x = LTR.get_trace("frequency") # Gets the frequency axis
steps = LTR.get_steps()

#tit=["vo1 vs. v1, v2","vo2 vs. v1, v2"]
tit="vo1 vs. v1, v2"

# print(np.real(V02.get_wave(0)[0]), np.imag(V02.get_wave(0)[0]))
# print(np.sqrt(np.real(V02.get_wave(0))**2+np.imag(V02.get_wave(0))**2))

# for step in range(len(steps)):
#     #recuperar modulo y fase
#     r,i = (np.real(trace.get_wave(0)), np.imag(trace.get_wave(0)))
#     # print(r,i)
#     mod=np.sqrt(r**2+i**2)
#     # print(mod)
#     phase = np.arctan2(i,r)

#     plt.figure()
#     plt.title(tit)
#     plt.plot(x.get_time_axis(step), mod, label=steps[step])
#     plt.xlabel("Hz")
#     plt.ylabel
#     plt.xscale('log')
#     plt.grid()
#recuperar modulo y fase

r,i = (np.real(trace.get_wave(0)), np.imag(trace.get_wave(0)))
# print(r,i)
mod=np.sqrt(r**2+i**2)
# print(mod)
phase = np.arctan2(i,r)

plt.figure()
plt.title(tit)
plt.plot(x.get_time_axis(0), mod, label=steps[0])
plt.xlabel("Hz")
plt.ylabel("Mag.")
plt.xscale('log')
plt.grid()

# order a legend
plt.legend("vo1")
plt.show()
