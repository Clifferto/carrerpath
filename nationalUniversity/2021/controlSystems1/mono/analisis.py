# Modulos
import numpy as np
import matplotlib.pyplot as plt
import sympy as spy
import control as ctl

# Funciones auxiliares
def mem2mem(equation,opp):
    """mem2mem:
        Aplica una operacion sencilla en ambos miembros de una ecuacion.

    Args:
        equation: Ecuacion a operar.
        opp: Termino para operar en ambos miembros.

    Returns: 
        Ecuacion de resultado luego de operar.
    """
    sel=opp[0]
    expr=spy.sympify(opp[1::])
    
    if sel=="+":
        return spy.Eq(equation.lhs+expr,equation.rhs+expr)
    elif sel=="-":
        return spy.Eq(equation.lhs-expr,equation.rhs-expr)
    elif sel=="*":
        return spy.Eq(equation.lhs*expr,equation.rhs*expr)
    elif sel=="/":
        return spy.Eq(equation.lhs/expr,equation.rhs/expr)

#########################################################################################################

#simbolos para las ecuaciones
# n = N1/N2 = W2/W1 = T1/T2
s,V,Im,Wm,Jm,bm,rm,lm,km,kv,T1,T2,W2,Tm,n,b2=spy.symbols("s,V,Im,Omega_m,Jm,bm,rm,lm,km,kv,T1,T2,Omega_2,Tm,n,b2")

#ecuaciones
print("Sistema:\n")
eqq1=spy.Eq(V,Im*(rm+s*lm)+kv*Wm)
eqq2=spy.Eq(Tm-Wm*bm-T1,Jm*Wm*s)
eqq3=spy.Eq(T2,W2*b2)

spy.pprint((eqq1,eqq2,eqq3))
print("-"*60)

# Tm = km*Im
# T2 = T1/n
eqq2=eqq2.replace(Tm,km*Im)
eqq3=eqq3.replace(T2,T1/n)

# eliminar T1 y T2
print("Eliminando T1 y T2:\n")
eqq2=mem2mem(eqq2,"-(Im*km-Omega_m*bm)")
eqq3=mem2mem(eqq3,"*n")

spy.pprint((eqq2,eqq3))

eqq4=spy.Eq(eqq2.lhs+eqq3.lhs,eqq2.rhs+eqq3.rhs)

spy.pprint(eqq4)
print("-"*60)

# cancelar la corriente
print("Eliminando Im:\n")
eqq4=mem2mem(eqq4,"+Im*km")
eqq4=mem2mem(eqq4,"/km")

eqq1=mem2mem(eqq1,"-Omega_m*kv")
eqq1=mem2mem(eqq1,"/(lm*s+rm)")

spy.pprint((eqq4,eqq1))

eqq5=spy.Eq(eqq4.lhs-eqq1.rhs,eqq4.rhs-eqq1.lhs)
spy.pprint(eqq5)
print("-"*60)

# funcion de transferencia
# Wm = W2/n
print("Relacion W2/V:\n")
eqq5=eqq5.replace(Wm,W2/n)

spy.pprint(eqq5)

eqqW2=spy.solve(eqq5,W2)
eqqV=spy.solve(eqq5,V)

spy.pprint(eqqW2/eqqV)

exit()

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
