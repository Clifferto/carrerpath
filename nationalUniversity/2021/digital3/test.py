from os import write
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as ss

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