# modulos
import PySimpleGUI as psg

# casos favorables/posibles
favorable=0
posible=0

# elementos de ventana
layout=[
    [psg.Button("Favorable +1"),psg.Text(f"Casos favorables: {favorable}.",key="fav")],
    [psg.Button("Posible +1"),psg.Text(f"Casos posibless: {posible}.",key="pos")],
    [psg.Button("Calcular"),psg.Button("Clear"),psg.Button("Quit")],
    [psg.Text(key="prob")]
]

# crear ventana
win=psg.Window("Probabilidades",layout)

# loop de accion
while True:
    
    # leer eventos de ventana
    event,values=win.read()

    # si cerrar o salir, finalizar
    if event=="Quit" or event==psg.WINDOW_CLOSED:
        break

    # si aumentar favorables
    elif event=="Favorable +1":
        # aumentar favorables y posibles
        favorable+=1
        posible+=1

        # actualizar
        win["fav"].update(f"Casos favorables: {favorable}.")
        win["pos"].update(f"Casos posibless: {posible}.")

    # si aumentar posibles
    elif event=="Posible +1":
        # solo aumentar posibles
        posible+=1

        # actualizar
        win["pos"].update(f"Casos posibless: {posible}.")
 

    # calcular probabilidad
    elif event=="Calcular":
        prob=(favorable/posible)*100

        # actualizar
        win["prob"].update(f"Probabilidad: {prob} %.")

    # inicializar variables
    else:
        # limpiar
        favorable=0
        posible=0

        # actualizar
        win["fav"].update(f"Casos favorables: {favorable}.")
        win["pos"].update(f"Casos posibless: {posible}.")
        win["prob"].update("")

print(f"Buen P/R si vela cierra sobre EMA200: 50.8 %")
print(f"Buen P/R si vela cierra > 50% sobre EMA200: 41.8 %")
print(f"Buen P/R si vela rompe la EMA200 con mas fuerza que las anteriores: %")
print(f"Buen P/R si cruce EMA200/EMA21: 49.5%")
print(f"Buen P/R si rebote a la EMA21, cruce EMA200/EMA21 y entrada en pullback a la EMA21: %")

# cerrar ventana
win.close()