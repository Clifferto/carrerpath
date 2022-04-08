# **FCEFyN - UNC - ELECTRÓNICA INDUSTRIAL**
## DOCENTE: Prof. Esp. Ing. Adrián Claudio Agüero
## ALUMNO: Ferraris Domingo Jesus

---------------------------------------
---------------------------------------

# **Trabajo practico teorico 4:** 
## Rectificacion.

-----------------------------------------

## **1. Mosfet elegido.** 

Se eligio el MOSFET de potencia IRF150 que nos sirve junto con las simulaciones a tener un estudio mas detallado del dispositivo.
El mismo es un transistor MOSFET de enrriquecimiento con encapsulado TO-3 para colocar en disipador, es fabricado con el proceso HEXFET de International Rectifier.

### **Caracteristicas.**

En la hoja de datos tenemos las siguientes caracteristicas principales:

![](./img/modData0.png)

![](./img/mosData1.png)

* IDM: 38A como maximo a 25°C (baja a 24A a los 100°C) y una corriente de pulso maxima de 152A durante 10us.
* VGSM: +/- 20V.
* PD: 150W con el encapsulado a 25°C.
* VDSbr: 100V como maxima VDS.
* RDSon: 55mOhm con corriente de drain de 24A, aumentando con la corriente a 65mOhm con ID maxima.
* VTO: En el rango de 2 a 4V. 
* IGSS: Una corriente de fuga entre gate y source de 100nA.

### **Safe operating area.**

![](./img/mosDataSoa.png)

Se interpreta en la curva el limite de corriente alcanzable debido a RDSon y los valores maximos admisibles de ID y VDS, para no dañar el transistor se debe operar dentro del area demarcada inferior-izquierda (SOA). 
Vemos como en todo momento si VDS es alta se debe trabajar a menor corriente y viceversa para no dañar el dispositivo.
Por ejemplo, si bien VDSbr e IDSM son 100V y 38A, para operar con una corriente de drain de 2A no hay que superar una VDS de 7V aprox. 
Ademas se muestran los resultados de pruebas por pulsos donde, por ejemplo se podria operar con una IDS arriba de 100A y manteniendo a VDS en 20V pero solo por menos de 10us.

### **Capacidades del MOS.**

El fabricante tambien nos da el valor de las capacidades principales para distintos valores de VDS.

![](./img/mosDataCap.png)

Se observa para una VDS de 1V que Cgd esta entorno a los 1.5nF, seguido por el Cds de 3.5nF y el mas grande Cgs del orden de 4nF y todos descienden con el aumento de VDS.
Ademas vemos como si bien Cds es de mas del doble de Cgd, desciende rapidamente con el aumento de VDS a diferencia de Cgs que ademas de ser la capacidad paracita mas grande disminuye lentamente con VDS a un ritmo similar a Cgd.

## **2. Simulaciones.**

Utilizando LTSpice se simulo la conmutacion del transistor de potencia N-MOS IRF150 y luego se compararon resultados con los del fabricante.

El manual nos da las caracteristicas de conmutacion del transistor y las definiciones de cada una.

![](./img/mosDataConmut.png)

![](./img/mosDataConditions.png)

* Define td(on) para VGS como el tiempo en subir la tension desde el 10% al 90% de la amplitud del pulso de prueba usado. Y td(off) como el tiempo que demora VGS en bajar del 90% al 10% del pulso aplicado.

* Ademas define tr como el tiempo que demora VDS en bajar del 90% al 10% de la tension aplicada y tf como el tiempo en subir del 10% al 90% de la tension aplicada.

El setup usado para las simulaciones fue el siguiente:

![](./img/mosConmutCirc.png)

Al aplicar el pulso de prueba se aprecian los retardos en la tension y corriente de drain debidos a la carga y descarga de las capacidades parasitas. 

![](./img/testTcp0.png)

Tambien se ven los picos de disipacion en el momento de la conmutacion debidos a la existencia de altas corrientes y tensiones simultaneamente.

![](./img/testTcp1.png)

Para el gate vemos como al aplicar el pulso de prueba azul se comienzan a cargar las capacidades distribuidas hasta llegar a la Vto donde empieza a aumentar la corriente IDS.
La tension sigue aumentando hasta que se carga Cgs donde se genera una meseta a los 6V aproximadamente, finalmente cuando el transistor supera la saturacion comienza a cargarse el capacitor Cgd lentamente hasta llegar a la tension maxima aplicada.

![](./img/testVg0.png)

Calculando el intervalo definido por el fabricante nos da un td(on) = 1.28us

Luego para el corte calculamos un td(off) = 1.08us.

![](./img/testVg1.png)

Los valores para td son bastante mas altos que los indicados por el fabricante, esto puede deberse a que el circuito de prueba suguerido para el practico tiene una resistencia RG mucho mas grande que la usada por el fabricante de 2.35ohm.

![](./img/testVds0.png)

![](./img/testVds1.png)








-------------------------------------
-------------------------------------

<!---
Insertar latex en pdf
--->

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<script type="text/x-mathjax-config">
    MathJax.Hub.Config({ tex2jax: {inlineMath: [['$', '$']]}, messageStyle: "none" });
</script>
