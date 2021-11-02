#from os import write
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as ss
import control as ct
import sympy as sp
from sympy.core import symbol
from sympy.core.function import expand
from sympy.matrices.common import NonInvertibleMatrixError
from sympy.polys.polyoptions import Symbols
 
#impedancias
s,Vi,Vo,R1,R2,R3,C1,C2,C3,Ad0,Wh=sp.symbols("s,Vi,Vo,R1,R2,R3,C1,C2,C3,Ad0,Wh")
# z1=1/(s*C1)+R1
# z2=1/(s*C2+1/R2)
# Ad=Ad0/(1+s/Wh)
# z3=R3/(R3+1/(s*C3))

#pasa banda pasivo
#eq de thevenin en la entrada
Vth=Vi*(1/(s*C1))/(1/(s*C1)+R1)
Zth=1/(s*C1+1/R1)

#tension de salida
Vo=Vth*R2/(R2+1/(s*C2)+Zth)

#respuesta del filtro
BPF=sp.factor(Vo/Vi)

nn=sp.numer(BPF)
dd=sp.denom(BPF)

nn=nn*(1/(C1*R1*C2*R2))
dd=sp.collect(sp.expand(dd*(1/(C1*R1*C2*R2))),s)

BPF=nn/dd
sp.pprint(BPF)

G1=(1/(s*C1)/(1/(s*C1)+R1)).factor()
G2=(R2/(R2+1/(s*C2))).factor()

BPFi=(G1*G2).expand()
nni=sp.numer(BPFi)
ddi=sp.denom(BPFi)

nni=nni*(1/(C1*R1*C2*R2))
ddi=sp.collect(sp.expand(ddi*(1/(C1*R1*C2*R2))),s)
sp.pprint(nni/ddi)

Zo=Zth
Zi=1/(s*C2)

print("-"*60)
sp.pprint(sp.Abs(Zo)**2)
print("<<<")
sp.pprint(sp.Abs(Zi)**2)

print("-"*60)
modo=1/((s*C1)**2+(1/R1)**2)
modi=Zi**2
sp.pprint(1/modo)
print(">>>")
sp.pprint(1/modi)

print("\nSi R1 > 1, Entonces: C1 > 10*C2 --> w1 << w2\n")



#denominador
a=dd.coeff(s,2)
b=dd.coeff(s,1)
c=dd.coeff(s,0)

wp12=((-b+sp.sqrt(b**2-4*a*c))/(2*a))
#sp.pprint(wp12)

# z1=sp.sympify("1/(s*C1)+R1")
# z2=sp.sympify("1/(s*C2+1/R2)")

##################################################

# with open("sign","r") as sin:
#     lin=sin.readline()
#     data=np.array(lin.split(",")[0:-1],dtype=("uint16"))
#     print(data)

#     plt.figure()
#     plt.plot(data)
#     plt.grid()
#     plt.show()
    
# exit()
# #ejes
# naxis=np.arange(-512,512)
# print(len(naxis))

# # Funciones
# #impulso
# resp=np.array([1 if n==0 else 0 for n in naxis],dtype="uint8")

# print(resp.shape)
# plt.figure()
# plt.stem(resp)
# plt.grid()
# plt.show()

# lin=0
# with open("respuestaDiscreta","w") as fil:
#     for i in resp:
#         if lin%55==0: 
#             fil.write(f"\n")
#         else: 
#             fil.write(f"{i},")
        
#         lin+=1