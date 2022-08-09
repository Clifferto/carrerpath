# calcular profit final de un PFUVA clasico, pre-cancelable y de hacer interes compuesto con un PF comun
# capital y meses del PF
cap=35*300
meses=3

# dolar actual
dolar=300

# precio del UVA actual
precio=137
# precio del UVA anterior 
precio0=116

# TNA en UVAs (PFUVA)
tasaUva=0.1/100
# TNA en pesos (PFUVA-Precanc)
tasaPesos=1/100
# TNA en pesos (PF-CLASICO)
tasaPf=61/100

# ---------------------------------------------------------------------------------------
# tiempo normalizado a 12 meses
t=meses/12

# coef de valorizacion del UVA en 3 meses (1+ajuste)
valUva=precio/precio0

# precio estimado del UVA si se mantienen las variables ctes
precioEst=precio*valUva

# ---------------------------------------------------------------------------------------
# PFUVA: capital a UVAs -> TNA en UVAs (+) -> UVAs a pesos (+) -> final
uva0=cap/precio
uva=uva0*(1+tasaUva*t)

capUva=uva*precioEst

# ---------------------------------------------------------------------------------------
# PFUVA-Precanc: capital a UVAs -> UVAs ctes -> UVAs a pesos (+) -> TNA en pesos (+) -> final
uvaPre=uva0

capUvaPre=uvaPre*precioEst*(1+tasaPesos*t)

profitUva=capUva-cap
profitUvaPre=capUvaPre-cap

print(valUva,capUva,capUvaPre)
print(f"UVA: {profitUva} ({profitUva/dolar} USD), PRE: {profitUvaPre} ({profitUvaPre/dolar} USD)")

# PF con interes compuesto: (1+TNA)**t
capComp=cap*(1+tasaPf)**t

profitComp=capComp-cap

print(capComp)
print(f"Interes compuesto en {meses} meses: {profitComp} ({profitComp/dolar} USD)")
