import numpy as np
import control as ct
import matplotlib.pyplot as plt

w=np.arange(0,100E6)

fo=10E6
wo=2*np.pi*fo

s=ct.tf('s')
kp=1/(3+s/wo+wo/s)

print(kp)

plt.figure()
plt.plot(ct.bode(kp,omega=w))
plt.grid()
plt.show()

