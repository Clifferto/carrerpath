# i. Conteste las siguientes preguntas:
-------------------------------------------------------------------------------------

* ## ¿Cómo utilizar typedef junto a struct? ¿Para qué sirve? Ejemplo.

> Permite crear ***tipos de dato definido por el usuario*** y hace mas claro el codigo. \
Ademas permite que un campo de una estructura sea de tipo estructura si antes se define como tipo. \
Es una aproximacion muy basica de las clases.

**Ejemplo:** *Lo usado en el ej2 para describir un array dinamico:*

```c
// descriptor del array dinamico
typedef struct{
    int size;
    char *ptr;
}DArray;
```

Podria crearse otro tipo con:

```c
typedef struct{
	int size;
	DArray ar0;
	DArray ar1;
}ArrayList;
```

* ## ¿Qué es packing and padding?

**Padding:** 

> Es perder bytes utiles de memoria para mantener el alineamiento, en pos de ***optimizar los accesos a memoria*** por hardware.

***Los pasos que sigue son:***

* Toma como alineamiento al ***elemento mas grande de la estructura.***
* Agrega padding (o basura) NECESARIA a los demas elementos para ***mantener alineamiento.***
* No se agrega padding a los arrays.

**Ejemplo:** *Para la estructura.*

```c
struct S{
	short int i;
	int n;
	char ch;
}st0;
```

**MEMORY:**

Addr | By0 | By1 | By2 | By3
---- | --- | --- | --- | ---
0x00 | i   | i   | pad | pad   
0x04 | n   | n   | n   | n 
0x08 | ch  | xx  | xx  | xx

***(Un acceso a memoria para trabajar con n)***

**Packing:** 

> Es anular lo anterior, le decimos al compilador que no agrege padding y ***ponga en orden los elementos de una estructura,*** porque por algun motivo no nos interesa la basura extra agregada.

**Ejemplo:** *Para la estructura.*

```c
struct S{
	short int i;
	int n;
	char ch;
}st0;
...
__packed__
```

**MEMORY:**

Addr | By0 | By1 | By2 | By3
---- | --- | --- | --- | ---
0x00 | i   | i   | n   | n   
0x04 | n   | n   | ch  | xx 

***(Dos accesos a memoria para trabajar con n)***

-------------------------------------------------------------------------------------

# Preguntas comentadas en lab2.c:
-------------------------------------------------------------------------------------

* ## Explique a que se debe los tamaños de cada una de las estructuras.

> Como el compilador siempre hace padding por default, la memoria queda:

```c
typedef struct {
    char a;
    char b;
    int  x;
    unsigned short int y;
    char c;
    unsigned short int z;
    char d[3];
} BaseData;
```

Addr | By0 | By1 | By2 | By3
---- | --- | --- | --- | ---
0x00 | a   | b   | pad | pad   
0x04 | x   | x   | x   | x 
0x08 | y   | y   | c   | pad
0x0C | z   | z   | d   | d
0x10 | d   | pad | pad | pad

**TOTAL: 20Bytes.**

---------------------------------------

> En este caso al reordenar la estructura se utiliza menos memoria:

```c
typedef struct {
    char a;
    char b;
    int  x;
    unsigned short int y;
    unsigned short int z;
    char c;
    char d[3];
} ReorderData;
```

Addr | By0 | By1 | By2 | By3
---- | --- | --- | --- | ---
0x00 | a   | b   | pad | pad   
0x04 | x   | x   | x   | x 
0x08 | y   | y   | z   | z
0x0C | c   | d   | d   | d

**TOTAL: 16Bytes.**

---------------------------------------

> Aca cambia el alineamiento a 8 Bytes:

```c
typedef struct {
    long unsigned int ll;
    char a;
    char b;
    unsigned short int y;
    int  x;
    unsigned short int z;
    unsigned short int w;
    char c;
    char d[3];
} ExtendedData;
```

Addr | By0 | By1 | By2 | By3 | By4 | By5 | By6 | By7
---- | --- | --- | --- | --- | --- | --- | --- | ---
0x00 | ll  | ll  | ll  | ll  | ll  | ll  | ll  | ll  
0x08 | a   | b   | y   | y   | x   | x   | x   | x   
0x10 | z   | z   | w   | w   | c   | d   | d   | d  

**TOTAL: 24Bytes.**

-----------------------------------------------

> Aca se empaqueta por lo que no se usa padding, todo va seguido en memoria:

```c
typedef struct  __attribute__((packed)) {
    char a;
    char b;
    int  x;
    unsigned short int y;
    char c;
    unsigned short int z;
    char d[3];
} BaseDataPacked;
```

Addr | By0 | By1 | By2 | By3
---- | --- | --- | --- | ---
0x00 | a   | b   | x   | x    
0x04 | x   | x   | y   | y 
0x08 | c   | z   | z   | d
0x0C | d   | d   |     | 

**TOTAL: 14Bytes.**

-------------------------------------------------------------------------------------

* ## Explique por que la expresion que calcula  limit y limit_aux generan el mismo resutado

```c   
char *limit = ((char *) &data + sizeof(BaseData)); 
char *limit_aux =(char *) (&data + 1);
```

> En el primer caso como el cast tiene mas precedencia que la suma, ***se castea el puntero a data a un puntero char y luego se le suma un 20.*** \
Sumar 20 a un puntero char es sumar 20*sizeof(char) == 20 Bytes, entonces si p es &data el resulatado seria:

### limit == (char *)(p + 20)

> Para el segundo caso primero se resuelven los parentesis de forma que ***al puntero a data se le suma 1 y luego se castea todo a un puntero char.*** \
Pero por lo mismo, sumar 1 a un putero a data es sumar 1*sizeof(data) == 20 Bytes, por lo que el resultado sigue  quedando:

### limit_aux == (char *)(p + 20) 

-------------------------------------------------------------------------------------

* ## Explique los valores que se muestran en pantalla en cada iteracion del for.

```c
int i = 0;

for (char *c = (char *) &data; c < limit; c++, i++ ){
	printf("byte %02d : 0x%02hhx \n", i, *c);
}
```

> Basicamente se recorren los miembros de la estructura byte a byte, imprimiendo incluso el padding.

* "%02d": Dice "mostrar el valor de i en decimal con 2 digitos, completar con 0s adelante".

* "0x%02hhx": Dice "Mostrar la derreferencia al puntero c como un unsigned char (basicamente un Byte en hex) con 2 digitos luego del 0x, y completar con 0s adelante".

Entonces se muestra a la salida:

> byte 00 : 0x01 == data.a \
byte 01 : 0x03 == data.b \
byte 02 : 0x00 == pad \
byte 03 : 0x00 == pad

> byte 04 : 0x0f == data.x (parte baja) \
byte 05 : 0x00 == data.x (partes altas) \
byte 06 : 0x00 == data.x \
byte 07 : 0x00 == data.x

> byte 08 : 0xff == data.y (65535 == 0xFFFF) \
byte 09 : 0xff \
byte 10 : 0x7f == data.c (127 == 0x7F) \
byte 11 : 0xf7 == pad

>byte 12 : 0xff == data.z (-1 en complemento 2 > ~(0x0001)+0x0001 == 0xFFFE+0x0001 == 0xFFFF) \
byte 13 : 0xff \
byte 14 : 0x01 == data.d[0] \
byte 15 : 0x01 == data.d[1]

> byte 16 : 0x01 == data.d[1] \
byte 17 : 0x00 == pad \
byte 18 : 0x00 == pad \
byte 19 : 0x00 == pad

