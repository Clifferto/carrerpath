import time
from time import sleep as ret
import serial
import matplotlib.pyplot as pl
import numpy as np

fftPoints=512
fSample=8000
qCuanto=15

def graf():
    data16=[((uart[u+1]|0x0000)<<8)|uart[u] for u in range(0,len(uart),2)]
    # data16=[]
    # for u in range(0,len(uart),2):
    #     #Si: uart=[0x5F,0x64] -> 0x0000|0x064=0x0064 -> 0x0064<<8=0x6400 -> 0x6400|0x5F=0x645F == q15
    #     q15=((uart[u+1]|0x0000)<<8)|uart[u]
    #     data16.append(q15)

    print("Restaurando q15..."); ret(.5)
    #format: {{index}:{width}{base}}
    print("Primer punto (HEX): {:x} + {:x}j == BIN({:#16b} + {:#16b}j)".format(data16[0],data16[1],data16[0],data16[1]))

    #pasar a float las partes real e imaginaria 
    #ECUACION: Float=(num + MSB*2**(-NB))*(-1**(MSB))
    #Si es positivo, hace la acumulacion de 2**(-1) hasta 2**(-15)
    #Si es negativo, luego de acumular suma 2**(-15) y multiplica por -1
    flot=[]
    for c in data16:
        #acumular segun potencias negativas
        bb=bin(c|0x10000)[3::]
        fp=0
        for s in range(1,len(bb)):
            if bb[s]=='1': fp+=2**-s
        #gestionar signo
        if bb[0]=='1': fp=-(fp+2**-qCuanto)    
        flot.append(fp)

    #si llego la CFFT
    if len(uart)==fftPoints*2*2:
        #crear la lista con la fft compleja
        ccft=[flot[cc]+1j*flot[cc+1] for cc in range(0,len(flot),2)]
        # cfft=[]
        # for cc in range(0,len(flot),2):
        #     cfft.append(flot[cc]+1j*flot[cc+1])

        print("Restaurando la FFT..."); ret(.5)
        print("{} PUNTOS: Primer punto de la FFT: {}".format(len(cfft),cfft[0]))

        #calcular el modulo de cada punto
        mod=[abs(cc) for cc in ccft]
        # mod=[]
        # for cc in cfft:
        #     mod.append(abs(cc))

        print("Calculando modulo..."); ret(.5)
        print("{} PUNTOS: Primer punto del espectro: {}".format(len(mod),mod[0]))

    #sino, llego el modulo
    else: mod=flot

    #grafica el espectro
    print("Graficando..."); ret(1)
    #pl.figure(figsize=(20,10))
    pl.figure()

    #LIST: [A:B] -> elementos [A;B) - CONCATENAR: La=[a,b] y Lb=[c,d], La+Lb=[a,b,c,d] 
    #reordenar y calcular el modulo
    g=mod[(fftPoints//2)::]+mod[0:(fftPoints//2)]
    #crear eje de frecuencias [-fSample/2;fSample/2]
    pl.plot(np.linspace(-fSample/2,fSample/2,fftPoints),g)
    pl.grid(which='both')
    pl.show()
    
    return

# ls -l /dev/serial/by-id/
 
p = serial.Serial(
    #Configurar con el puerto
    port='/dev/ttyACM0',	
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

p.isOpen()
p.timeout=5

print("\nfrdm-k64f - PlotFFT (Timeout: {} seg.)".format(p.timeout))

# Panel inicial
print("-"*40)
print("\nLectura : rc -> CFFT - rm -> MODULO DE LA FFT")
print("\nTerminar conexion: qq\n")

while True:
    #pide y limpia el comando
    comm=input("comm$_: ").lower().strip()
    
    #si qq, salir
    if(comm=='qq'): 
        p.close()
        break

    #si rc, leer la CFFT
    elif comm=='rc':
        uart=bytearray(p.read(fftPoints*2*2))        
        print("{} bytes de la UART (CFFT)".format(len(uart)))
        p.close()
        graf()
        break

    #si rm, leer el modulo
    elif comm=='rm':
        uart=bytearray(p.read(fftPoints*2))       
        print("{} bytes de la UART (MOD FFT)".format(len(uart)))
        p.close()
        graf()
        break

    #sino, error
    else:
        #envia comando
        print("FATAL_ERROR_ROMPISTETODO_CARLA")        