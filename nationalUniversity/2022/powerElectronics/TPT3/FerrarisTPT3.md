# FCEFyN - UNC - ELECTRÓNICA INDUSTRIAL
## DOCENTE: Prof. Esp. Ing. Adrián Claudio Agüero
## ALUMNO: Ferraris Domingo Jesus

---------------------------------------
---------------------------------------

# Trabajo practico teorico 2: 
## Diodos de potencia.

-----------------------------------------
con carga resistiva

![](./img/cargaR.png)

![](./img/db1.png)

![](./img/dc1.png)

![](./img/da1.png)

![](./img/irl.png)

la tension en la carga es un multiplo de la corriente, tiene la misma forma de continua pulsante

con carga inductiva, viendo hacia la carga se tiene una impedancia muy grande para la corriente de señal, por lo tanto esta es nula
y solo hay corriente continua por los diodos

![](./img/cargaL.png)

![](./img/db1L.png)

![](./img/dc1L.png)

![](./img/da1L.png)

conclusion de una carga RL





## 1. Diodo elegido.
Se eligio para el analisis el ***diodo rectificador de potencia 46DN06B02.***
* Fabricante: Infineon Technologies Bipolar.
* Aplicaciones: Soldaduras, rectificacion para circuitos galvanicos, rectificacion de alta corriente.

<img src="./img/dataDiodo0.png" width="400" height="auto"/>

### Caracteristicas electricas:

<img src="./img/dataDiodo1.png" 
     width="600" 
     height="auto"/>

* ***IF(av)M:*** 10.45KA a una temperatura de operacion de 55°C ***decayendo a 7.74KA operando a 100°C***.
* ***IFRMS:*** 16.4KA a una temperatura de operacion de 55°C ***decayendo a 12.2KA operando a 100°C***.
* ***IFSM:*** 55KA a una temperatura de juntura de 25°C ***decayendo a 48KA con temperatura de juntura maxima (180°C)***.
* Todas las corrientes probadas durante un tiempo de 10ms.
* ***VRRM = VRRW:*** 600V para temperatura de juntura de -40 a 180°C.
* ***Energia I2T:*** 15.125K(A^2)s a una temperatura de juntura de 25°C ***decayendo a 11.52K(A^2)s a temperatura de juntura maxima.***
* ***Tension de umbral 0.7 a 0.78V*** y caida de tension maxima: 0.98V, con temperatura de juntura maxima y corriente de prueba de 6KA.

### Potencia disipada vs IF(av):

En esta grafica vemos la ***potencia media maxima admisible segun la corriente media directa de trabajo***, colocando disipadores a ambos lados del diodo.

Las parametricas corresponden a corriente continua, semiciclo senoidal, y rectificando con angulos de conduccion de 30°, 60°, 90°, 120° y 180°.

![](./img/dataDiodoPvsIF.png)

En cada punto tenemos la ***potencia maxima disipada para cada valor de corriente media directa.*** Los extremos de las curvas corresponden a la maxima potencia admisible para la maxima corriente media ensayada.

### Encapsulado e instalacion:

Tiene un ***encapsulado de tipo disco E35***, que se coloca con 2 disipadores formando un "sandwich".

Para un ***rectificador trifasico de onda completa con carga resistiva*** el esquema puede ser el siguiente:

![](./img/trafoPuenteCarga.png)

Este tipo de diodos tiene el catodo y el anodo en cada una de sus caras planas, por lo tanto ***lleva disipador de ambos lados.*** Para su montaje se deben tener los disipadores del tamaño adecuado con una de sus caras plana y limpia, el diodo se coloca en el medio de ambos disipadores (tipo sandwich) usando grasa siliconada para mejorar la conduccion térmica. Se instala ***un conjunto de disipadores por cada diodo.*** 

Cada disipador pasa a ser un polo del diodo, por lo que es vital que esten ***completamente aislados entre ellos.***

El conjunto se presiona entre si con tornillos aislados y cuidando de ***no superar el torque maximo*** dado por el fabricante.

Una vez colocados los disipadores en los 6 diodos se toma un grupo de 3 y se conecta ***cada anodo a una fase***, luego se conectan todos ***los catodos del grupo a la carga***. Con el grupo restante de 3 diodos conectamos ***cada catodo a una fase*** y todos ***los anodos al otro terminal de la carga.***

------------------------------------
------------------------------------

## 2. Simulaciones/comparaciones

Se compararon los ***diodos MR850 y 1N4148*** en transitorios de corriente y tension para conduccion/corte. Ademas se compararon los ***tiempos de recuperacion maximos*** de cada uno.

### Tipos de diodos:

En los datasheets vemos que el MR850 es un ***diodo rectificador de alta corriente y rapida recuperacion (Fast).***

![](./img/diodoMR0.png)

Con un Trr de 150ns, para las ***condiciones de prueba definidas:***
* Estar conduciendo una corriente de 0.5A.
* Pasar al corte con un pico de corriente inversa de 1A.
* Esperar hasta que la corriente inversa alcance los 0.25A.

![](./img/diodoMR1.png)

Por otro lado, el 1N4148 es un ***diodo de baja corriente y conmutacion de alta velocidad (Ultra Fast).***

![](./img/diodo1N0.png)

Este tiene un Trr de 8ns como maximo, ***para las siguientes condiciones de prueba:***
* Conducir una corriente de 10mA.
* Pasar al corte con un pico de corriente inversa de 10mA.
* Esperar hasta que la corriente inversa alcance 1mA.

![](./img/diodo1N1.png)

### Circuito de test:

Los fabricantes prueban el tiempo de recuperacion inversa con un circuito similar al siguiente:

![](./img/testCirc.png)

Que se armo en LTSpice ***colocando tensiones y resistencias de tal forma que se respeten las condiciones de prueba para cada diodo.***

![](./img/diodoLT.png)

En todos se le ***aplico un pulso a los 100ns***, para cambiar el estado de conduccion de los diodos.

**Analisis MR850:**

Forzando la conduccion al aplicar el pulso de prueba celeste, se nota un importante ***pico de corriente***, en verde, mayor al triple de la corriente de operacion, por lo que hay una ***importante disipacion de energia*** en este caso cercana a los 9W como se ve en la grafica roja:

![](./img/MRtest0.png)

Forzando el corte vemos el tiempo que tarda el diodo en establecer su caida de tension en azul, cuando el pulso de prueba celeste se aplica, ***el diodo demora en hacer caer toda la tension inversa aplicada***, lo cual genera el pico de corriente inversa de 1A:

![](./img/MRtest1.png)

Luego al reaccionar el diodo estabilizando su caida de tension y ***bloqueando bruscamente la corriente*** se produce otro pico de energia disipada de casi 2W.

**Analisis 1N4148:**

Forzando la conduccion al aplicar el pulso de prueba celeste, se nota un ***importante pico de corriente*** mayor al triple de la corriente de operacion, por lo que tambien hay un pico de disipacion de energia como se ve en la grafica roja:

![](./img/1Ntest0.png)

En este caso forzando el corte cuando el pulso de prueba celeste se aplica, vemos que el diodo ***establece gradualmente su caida de tension en azul***. Durante esta demora se genera el pico de corriente inversa, pero en este caso se recupera mucho mas rapido pero ***gradualmente*** lo que amortigua el pico de energia disipada que se veia en el MR850:

![](./img/1Ntest1.png)

### Comparacion del tiempo de recuperacion maximo:

Tambien se simularon los tiempos de recuperacion respetando las condiciones de prueba para ambos diodos, y ***cortando la conduccion a los 100ns:***

![](./img/diodosTRR.png)

Que nos deja un Trr = 150ns para el MR850, acorde al maximo dado por el fabricante.

Y para el 1N4148 un Trr = 16ns el cual el doble de los 8ns que nos da el fabricante. ***Esto se debe al parametro tt = 20ns del modelo generico usado:***

![](./img/TTDel1N.png)

En efecto bajando este parametro a 10ns se obtiene un Trr acorde al dado por el fabricante del 1N4148:

![](./img/1NnuevoTT.png)

Pero esto es cambiar el modelo Spice del diodo, por lo que, segun de que fabricante se trate la simulacion ***puede o no reproducir una situacion real.***

-------------------------------------
-------------------------------------
