import numpy as np
import matplotlib.pyplot as plt
import sympy as sym
import control as ct

# Parametros
#sensor(V/°): +/-5V a +/- 20°
ssr=5/20
#pwm(%D/V): +/-5V es +/-100D%
pwm=1/5 
#ganancia(V/%D): +/-100D% son +/-12V
gv=12/100

#MOTOR: FAULHABER 012CXR
#cte motor(mNm/A)>(mNcm/A)
km=(14.48)*100
#cte fcem(V/rpm)>(V/rps)
kv=1.515/(2*np.pi/60)
#inercia del rotor(gr/cm2)>(kg/cm**2)
jm=1.6/1000
#friccion(mNm*s)>(mNcm*s): Kf=.29mNm, Wnom=7500rpm
bm=.29*100/(7500*2*np.pi/60)
#resistencia(ohm)
rm=5.8
#inductancia(Hy)
lm=135E-6

#caja reductora
ke=1/4

# SEGUIDOR
#disco dentado de pla: h=1cm, r=5cm, densidad=1.32gr/cm3, J=1/2*densidad*vol*r**2
densidad=1.32/1000
radio=5
vol=(np.pi*radio**2)*1

#inercia
j=1/2*densidad*vol*radio**2
#friccion 
b=4*bm

# Ecuaciones
#ganancias
ssrSy,pwmSy,gvSy,keSy=sym.symbols("ssrSy,pwmSy,gvSy,keSy".replace(","," "))

ctes=ssrSy*pwmSy*gvSy

print("\nGanancias:")
sym.pprint(ctes)

#planta
kmSy,kvSy,jmSy,bmSy,rmSy,lmSy,jSy,bSy,s=sym.symbols("kmSy,kvSy,jmSy,bmSy,rmSy,lmSy,jSy,bSy,s".replace(","," "))

numSy=kmSy*keSy
denSy=(keSy**2*(s*jSy+bSy)*(rmSy+s*lmSy)+(s*jmSy+bmSy)*(rmSy+s*lmSy)+kvSy*kmSy)
planta=numSy/denSy

print("\nPlanta:")
sym.pprint(planta)

#fuciones en serie
ec0=ctes*planta*(1/s)

numSy,denSy=sym.fraction(ec0)
numSy=sym.collect(sym.expand(numSy),s)
denSy=sym.collect(sym.expand(denSy),s)

#sistema completo
ec1=numSy/denSy

print("\nSistema completo:")
sym.pprint(ec1)

# FTLA
#reemplazo parametros
ec2=ec1.subs([(ssrSy,ssr),(pwmSy,pwm),(gvSy,gv),(keSy,ke),
            (kmSy,km),(kvSy,kv),(jmSy,jm),(bmSy,bm),(rmSy,rm),(lmSy,lm),
            (jSy,j),(bSy,b)])

#sistema valuado
print("\nValuado:")
sym.pprint(ec2)

#extraer coeficientes del polinomio
N,D=sym.fraction(ec2)
N=[N.coeff(s,i) for i in range(0,1)][::-1]
D=[D.coeff(s,i) for i in range(0,4)][::-1]

print(f"\nNUM: {N}\nDEN: {D}")

# Lazo abierto
ftla=ct.tf([2.17200000000000], [1.11502150560488, 0.479052507398121, 20948.7506041874, 0])

#ftla=ct.tf([2],[1e-3,.5,2,0])
print(ftla)

# a,b=ct.step_response(ftla)
plt.figure()
plt.plot(ct.step_response(ftla)[1])
plt.grid()
plt.show()
