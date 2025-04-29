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
def pfUva():   
    # pasar a UVAs
    uva0=cap/precio

    # PFUVA: capital a UVAs -> TNA en UVAs (+) -> UVAs a pesos (+) -> final
    # aplicar TNA en UVAs
    uva=uva0*(1+tasaUva*t)
    # venta de UVAs en el vencimiento
    capUva=uva*precioEst

    # PFUVA-Precanc: capital a UVAs -> UVAs ctes -> UVAs a pesos (+) -> TNA en pesos (+) -> final
    # UVAs contantes
    uvaPre=uva0
    # venta de las UVAs en el vencimiento
    capUvaPre=uvaPre*precioEst
    # aplicar TNA en pesos
    capUvaPre*=(1+tasaPesos*t)

    return capUva,capUvaPre

# ---------------------------------------------------------------------------------------
capUva,capUvaPre=pfUva()

profitUva=capUva-cap
profitUvaPre=capUvaPre-cap

print(valUva,capUva,capUvaPre)
print(f"UVA: {profitUva} ({(profitUva/cap)*100}%, {profitUva/dolar} USD)")
print(f"UVA-PRE: {profitUvaPre} ({(profitUvaPre/cap)*100}%, {profitUvaPre/dolar} USD)")

# PF con interes compuesto: (1+TNA)**t
capComp=cap*(1+tasaPf)**t

profitComp=capComp-cap

print(capComp)
print(f"Interes compuesto en {meses} meses: {profitComp} ({(profitComp/cap)*100}%, {profitComp/dolar} USD)")
