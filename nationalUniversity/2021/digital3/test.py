#from os import write
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as ss
import control as ct
import sympy as sp
from sympy.core import symbol
from sympy.core.function import expand
from sympy.polys.polyoptions import Symbols
 
# #impedancias
# s,R1,R2,R3,C1,C2,C3,Ad0,Wh=sp.symbols("s,R1,R2,R3,C1,C2,C3,Ad0,Wh")
# z1=1/(s*C1)+R1
# z2=1/(s*C2+1/R2)
# Ad=Ad0/(1+s/Wh)
# z3=R3/(R3+1/(s*C3))

# # z1=sp.sympify("1/(s*C1)+R1")
# # z2=sp.sympify("1/(s*C2+1/R2)")

# sp.pprint(sp.factor(-(z2/z1)*Ad*z3))
##################################################3
with open("sign","r") as sin:
    lin=sin.readline()
    data=np.array(lin.split(",")[0:-1],dtype=("uint16"))
    print(data)

    plt.figure()
    plt.plot(data)
    plt.grid()
    plt.show()
    
exit()
#ejes
naxis=np.arange(-512,512)
print(len(naxis))

# Funciones
#impulso
resp=np.array([1 if n==0 else 0 for n in naxis],dtype="uint8")

print(resp.shape)
plt.figure()
plt.stem(resp)
plt.grid()
plt.show()

lin=0
with open("respuestaDiscreta","w") as fil:
    for i in resp:
        if lin%55==0: 
            fil.write(f"\n")
        else: 
            fil.write(f"{i},")
        
        lin+=1