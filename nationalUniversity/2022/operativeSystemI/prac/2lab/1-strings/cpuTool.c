// cpu info tiene demasiada info repetida 
// por lo que solo se procesaron LAS LINEAS NECESARIAS

// [clifferto@clifferto-sys 1-strings]$ head --lines=15 /proc/cpuinfo 
// processor	: 0
// vendor_id	: AuthenticAMD
// cpu family	: 16
// model		: 5
// model name	: AMD Athlon(tm) II X3 425 Processor
// stepping	: 2
// microcode	: 0x10000db
// cpu MHz		: 2700.000
// cache size	: 512 KB
// physical id	: 0
// siblings	: 3
// core id		: 0
// cpu cores	: 3
// apicid		: 0
// initial apicid	: 0

// toda la info necesaria esta en las primeras 15 lineas

// ------------------------------------------------------------------------------------------------------------------

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// caracteres maximos por linea
#define CHARpLINE 100

int main(){

    // abrir archivo
    FILE *cpuinfo=fopen("/proc/cpuinfo","r");
    // buffer de linea
    char line[CHARpLINE]="";

    // inicializar a cero los arrays
    char model[CHARpLINE]="";
    char cores[3]="";
    char siblings[3]="";

    // contador de parametros encontrados
    int ready=0;
    
    // para todo el archivo
    while(!feof(cpuinfo)){
        
        // leer linea hasta '\n' (new-line terminated string)
        fgets(line,CHARpLINE,cpuinfo);

        // reemplazar espacio luego de ':' por '\0' (para busqueda)    
        for(int cc=0;line[cc]!='\0';cc++){
            if(line[cc]==':') line[cc+1]='\0';
        }
        
        // si campo "model name"
        if(strcmp(line,"model name\t:")==0){

            // indice al proximo caracter
            int base=(int)(strlen("model name\t:")+1);    

            // guardar campo hasta '\n'
            for(int offset=0;line[base+offset]!='\n';offset++) model[offset]=line[base+offset];
            ready++;
        }

        // si campo "cpu cores"
        else if(strcmp(line,"cpu cores\t:")==0){

            // indice al proximo caracter
            int base=(int)(strlen("cpu cores\t:")+1);    

            // guardar campo hasta '\n'
            for(int offset=0;line[base+offset]!='\n';offset++) cores[offset]=line[base+offset];
            ready++;
        }

        // si campo "siblings"
        else if(strcmp(line,"siblings\t:")==0){

            // indice al proximo caracter
            int base=(int)(strlen("siblings\t:")+1);    

            // guardar campo hasta '\n'
            for(int offset=0;line[base+offset]!='\n';offset++) siblings[offset]=line[base+offset];
            ready++;
        }  

        // si se encontraron todos los parametros, finalizar
        if(ready==4) break;
    }
    
    // cerrar archivo
    fclose(cpuinfo);

    // requerido por strtol()
    char *end;

    // pasar a numeros para operar
    int numCores,numSiblings;
    
    numCores=(int)(strtol(cores,&end,10));
    numSiblings=(int)(strtol(siblings,&end,10));

    // mostrar resultados
    printf("Crear un programa en C que imprima información referida al CPU, a partir del archivo /proc/cpuinfo:\n\n");
    printf("\ti. Modelo de CPU: %s\n",model);
    printf("\tii. Numero de cores: %i\n",numCores);
    printf("\tiii. Numero de threads/core: %i\n\n",(int)(numSiblings/numCores));

    return 0;
}

// ------------------------------------------------------------------------------------------------------------------
// compilacion/ejecucion
// [clifferto@clifferto-sys 1-strings]$ gcc -Wall -Wextra -Werror -pedantic cpuTool.c --output bin/cpuTool
// [clifferto@clifferto-sys 1-strings]$ ./bin/cpuTool 

