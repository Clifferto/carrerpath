## Funciones
def interp(x0,fx0,x1,fx1,x):
    return ((fx1-fx0)/(x1-x0))*(x-x0) + fx0

#########################################################

## Primero con metodo de cav zonales para tubos fluorecentes de 2x36W = 6000lms
## Repetir con luminarias LED donde cu*fm = 0.6
## Repetir con software

# https://llumor.es/info-led/equivalencia-lumen-a-vatios-tubos-fluorescentes/
# ## Tubos fluorescentes
# fi=3000*2
# fm=.8

## Tubos LED
fi=2800*2
#fm*cu = .6

# Caracteristicas
# #local1
# a=6.5; l=7
# h1=2.8; h2=0.4; h3=0.8

# #reflectancias (pared,cielo razo,piso)
# r1=50; r2=80; r3=30

# #Cerámica,preparacion y amasado arcillas
# Em=200

#local2
# a=4.2; l=4.5
# h1=2.2; h2=0.4; h3=0.9

# #reflectancias (pared,cielo razo,piso)
# r1=70; r2=80; r3=20

# #Cerámica,barnizado y decoración (trabajos finos)
# Em=800

#local3
a=3.5; l=3.5
h1=2.3; h2=0; h3=0.8

#reflectancias (pared,cielo razo,piso)
r1=50; r2=50; r3=20

#Cerámica, Inspección
Em=1000

## Indices
k=5*(a+l)/(a*l)

k1=k*h1; k2=k*h2; k3=k*h3

print("-"*100)
print(f"Indices k1, k2, k3: {k1,k2,k3}\n")

## Reflect efectiva cielo razo
#local1 (ro1,ro2,k2)=(50,80,.6) -> Ref efectiva cielo razo
r2E=70

# #local2 (ro1,ro2,k2)=(70,80,1) -> Ref efectiva cielo razo
# r2E=70

# #local3 Embutida -> Ref efectiva cielo razo
# r2E=50

## Reflectancia efectiva piso
# #local1 (ro3,ro1,k3)=(50,80,.6) -> Ref efectiva piso
r3E=30

# #local2 20% -> Ref efectiva piso
# r3E=20

# #local3 20% -> Ref efectiva piso
# r3E=20

print("-"*100)
print(f"Reflectividad eficaz tomada Cielo razo/Piso: {r2E}/{r3E}\n")

## Coef de utilizacion
# #local1 (ro2E,ro1,k1)=(70,50,4) -> TABLA A
# cu0=.48

# #local2 (ro2E,ro1,k1)=(70,70,5) -> TABLA A
# cu0=.50

# #local3 INTERPOLAR entre 6 y 7
# # (50,50,6) -> .37
# # (50,50,7) -> .34
# cu0=interp(6,.37,7,.34,6.6)

#correccion
# #local 1 (r2E,r1,k1)=(70,50,4) -> TABLA I
# corr=1.04

# #local 2 20% -> TABLA I
# corr=1

#local 3 20% -> TABLA I
corr=1

#correcion para 30 o 10%
#cu=cu0*corr

print("-"*100)
#print(f"Cu basico: {cu0}, Factor de correccion: {corr}, Correccion para 20%: {cu}\n")

## Cantidad de luminarias
#num0=(Em*a*l)/(cu*fm*fi)
num0=(Em*a*l)/(.6*fi)
#cantidad usada
num=4

print("-"*100)
print(f"Cantidad teorica de luminarias: {num0} -> Usadas: {num}")

## Presentacion
adis=a/2
ldis=l/2

print("-"*100)
print(f"{num} luminarias:\n" +
      f"\ta: {a/adis:.0f} lineas -> ({adis/2:.1f}, << {adis:.1f} >> ,{adis/2:.1f}) mts = [{adis/2+(a/adis-1)*adis+adis/2:.1f}] mts\n" +
      f"\tl: {l/ldis:.0f} lineas -> ({ldis/2:.1f}, << {ldis:.1f} >> ,{ldis/2:.1f}) mts = [{ldis/2+(l/ldis-1)*ldis+ldis/2:.1f}] mts\n")

## Verificacion.
#Efinal=(num*fi*cu*fm)/(a*l)
Efinal=(num*fi*.6)/(a*l)

print("-"*100)
print(f"Nivel obtenido: {Efinal:.1f}\n")