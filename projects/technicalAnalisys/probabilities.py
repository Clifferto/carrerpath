import PySimpleGUI as psg

# casos favorables/posibles
favorable=[0,0]
posible=[0,0]

# nombre de estudios
estudio0="E: Cruce/Abs/Rebote"
estudio1="Rompe y apoya si HullMA rompe"

# areas a dividir la ventana total
area0=psg.Frame(estudio0,[[psg.Button("Favorable0 +1"),psg.Text(f"Casos favorables: {favorable[0]}.",key="fav0")],
                          [psg.Button("Posible0 +1"),psg.Text(f"Casos posibless: {posible[0]}.",key="pos0")],
                          [psg.Button("Calcular0"),psg.Button("Clear0")],
                          [psg.Text(key="prob0")]],
                          element_justification="c")

# area1=psg.Frame(estudio1,[[psg.Button("Favorable1 +1"),psg.Text(f"Casos favorables: {favorable[1]}.",key="fav1")],
#                           [psg.Button("Posible1 +1"),psg.Text(f"Casos posibless: {posible[1]}.",key="pos1")],
#                           [psg.Button("Calcular1"),psg.Button("Clear1")],
#                           [psg.Text(key="prob1")]],
#                           element_justification="c")
area1=[]

# elementos de ventana
layout=[[area0,area1],
        [psg.Button("Quit")]]

# crear ventana
win=psg.Window("Probabilidades",layout,resizable=True)

# loop de accion
while True:
    
    # leer eventos de ventana
    event,values=win.read()

    # si cerrar o salir, finalizar
    if event=="Quit" or event==psg.WINDOW_CLOSED:
        break

    # si aumentar favorables
    # ----------------------------------------------------------------------------------------------
    elif event=="Favorable0 +1":
        # aumentar favorables y posibles
        favorable[0]+=1
        posible[0]+=1

        # actualizar
        win["fav0"].update(f"Casos favorables: {favorable[0]}.")
        win["pos0"].update(f"Casos posibless: {posible[0]}.")

    elif event=="Favorable1 +1":
        # aumentar favorables y posibles
        favorable[1]+=1
        posible[1]+=1

        # actualizar
        win["fav1"].update(f"Casos favorables: {favorable[1]}.")
        win["pos1"].update(f"Casos posibless: {posible[1]}.")

    # si aumentar posibles
    # ----------------------------------------------------------------------------------------------
    elif event=="Posible0 +1":
        # solo aumentar posibles
        posible[0]+=1

        # actualizar
        win["pos0"].update(f"Casos posibless: {posible[0]}.")
 
    elif event=="Posible1 +1":
        # solo aumentar posibles
        posible[1]+=1

        # actualizar
        win["pos1"].update(f"Casos posibless: {posible[1]}.")

    # calcular probabilidad
    # ----------------------------------------------------------------------------------------------
    elif event=="Calcular0":
        prob0=(favorable[0]/posible[0])*100

        # actualizar
        win["prob0"].update(f"Probabilidad: {prob0} %.")

    elif event=="Calcular1":
        prob1=(favorable[1]/posible[1])*100

        # actualizar
        win["prob1"].update(f"Probabilidad: {prob1} %.")

    # inicializar variables
    # ----------------------------------------------------------------------------------------------
    elif event=="Clear0":
        # limpiar
        favorable[0]=0
        posible[0]=0

        # actualizar
        win["fav0"].update(f"Casos favorables: {favorable[0]}.")
        win["pos0"].update(f"Casos posibless: {posible[0]}.")
        win["prob0"].update("")

    elif event=="Clear1":
        # limpiar
        favorable[1]=0
        posible[1]=0

        # actualizar
        win["fav1"].update(f"Casos favorables: {favorable[1]}.")
        win["pos1"].update(f"Casos posibless: {posible[1]}.")
        win["prob1"].update("")

# cerrar ventana
win.close()

# ---------------------------------------------------------------------------------------

# rupturas velas/EMAs
print(f"Buen P/R si vela cierra sobre EMA200: 50.8 %")
print(f"Buen P/R si vela cierra > 50% sobre EMA200: 41.8 %")
# cruce de EMAs
print(f"Buen P/R si cruce EMA200/EMA21: 49.5%")
print(f"Si cruce entre EMA200/EMA21, entonces keylvl claro en mismo punto o muy cerca: 57.8 %")
print(f"Si cruce entre EMA200/EMA21, entonces keylvl muy cerca y rebote a la EMA21 para continuar mov: 38.9 %")
print(f"Buen P/R si cruce entre EMA200/EMA21, entrar en rebote a la EMA21 (salida maxima en siguiente cruce): 57.9 % (E0 4h/1h)")
print(f"Buen P/R con E1 en 15m/5m: %")
print(f"Buen P/R con E1 en 15m/5m, saliendo en proximo cruce del DMI: %")
# correlaciones
print(f"Correlacion entre P/R y fuerza del movimiento al momento de entrar (aplicando E0): 45.5 %")
print(f"Correlacion entre P/R y fuerza del movimiento al momento del cruce (aplicando E0): 50 %")
print(f"Buen P/R si cruce entre EMA21/EMA55 con fuerza, entrar en rebote a la EMA21: 56.8 % (E1 4h/1h)")
# riesgos del tralling stop
print(f"Aplicando E1 (poniendo SL en el area del ultimo keylvl), se sufre perdida haciendo tralling-stop: 33.3 %")
print(f"Aplicando E1 saliendo al romper linea de tendencia entre cruce y entrada, se pierden buenos movimientos: 40.5 %")
# fuerza del ADX
print(f"Si cruce entre EMA21/EMA55, finaliza el movimiento cuando el ADX esta debajo del 25:  %")
# divergencias
print(f"E1 falla si hay divergencia: %")
print(f"Rebotes en EMA luego de una vela de presion seguida de una con cuerpo: 52.8%")
print(f"Rebotes siempre que se forma un vertice en la HullMA5: 89.8%")
print(f"Rebotes falsos cuando se forma un vertice en la HullMA5: %")

# ESPERAR
# Cruce de EMA50/EMA21 -> absorcion -> rebote a la EMA21 o EMA10 -> vertice en la HullMA5 hl2. 

# ENTRADA
# Posible entrada si el rebote es claro y el ADX muestra fuerza.
# Calculo del SL por volumen profile y accion del precio.
# - Ayuda a la entrada que la zona de ruptura de volumen medio, este a favor de la tendencia.

# SALIDA
# Salida si rompe la tendencia de regresion/linea de tendencia entre inicio del movimiento y entrada.
# - Ayuda a la salida un cruce anterior en el DMI o el ADX no muestre fuerza e impulso contratendencial.
print("Profit con estrategia: 50% (E2)")
