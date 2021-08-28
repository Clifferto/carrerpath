from matplotlib.pyplot import plot as plt
from PyLTSpice.LTSpice_RawRead import LTSpiceRawRead


LTR = LTSpiceRawRead("tpl1.raw") 

print(LTR.get_trace_names())
print(LTR.get_raw_property())

y = LTR.get_trace("v(n003)")
x = LTR.get_trace('frecuency') 

steps = LTR.get_steps()

for step in range(len(steps)):
     # print(steps[step])
     plt(x.get_time_axis(step), y.get_wave(step), label=steps[step])

plt.legend() # order a legend
plt.show()