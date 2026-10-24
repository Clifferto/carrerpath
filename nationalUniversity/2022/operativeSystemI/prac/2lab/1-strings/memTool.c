// el comando "free" con la opcion --mebi parsea el contenido de /proc/meminfo 
// y da la cantidad de memoria en Megabytes
// Asi que teoricamente seria valido para el punto(?

// ------------------------------------------------------------------------------------------------------------------
// obtener lineas, palabras y caracteres de meminfo

// [clifferto@clifferto-sys soi---2022---laboratorio-2-Clifferto]$ wc --lines --words --chars /proc/meminfo 
// 53 155 1475 /proc/meminfo

// ------------------------------------------------------------------------------------------------------------------
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// pensarlo como una tabla de strings con ROWS filas, COL columnas y CHARpSTR caracteres por string    
#define ROWS 53
#define COL 3
#define CHARpSTR 50

// nombre de columnas de la tabla
enum columns {name,value,unit};

int main(){
    
    // abrir archivo
    FILE *meminfo=fopen("/proc/meminfo","r");

    // guardar archivo como una tabla en memoria
    char tab[ROWS][COL][CHARpSTR];

    // para cada fila
    for(unsigned int ff=0;ff<ROWS;ff++){
        
        // levantar las columnas name-value-unit
        fscanf(meminfo,"%s%s%s\n",tab[ff][name],tab[ff][value],tab[ff][unit]);
    }

    // cerrar el archivo
    fclose(meminfo);

    // filas con los valores requeridos
    unsigned int tot,free,avail,swTot,swFree;

    // para cada fila
    for(unsigned int ff=0;ff<ROWS;ff++){

        // guardar fila memtotal
        if(strcmp(tab[ff][name],"MemTotal:")==0) tot=ff;

        // guardar fila memfree
        if(strcmp(tab[ff][name],"MemFree:")==0) free=ff;

        // guardar fila memavailable
        if(strcmp(tab[ff][name],"MemAvailable:")==0) avail=ff;

        // guardar fila swaptotal
        if(strcmp(tab[ff][name],"SwapTotal:")==0) swTot=ff;

        // guardar fila swapfree
        if(strcmp(tab[ff][name],"SwapFree:")==0) swFree=ff;
    }

    // puntero requerido para strtol()
    char *end=(char*)(NULL);

    // pasar de kB a MB
    float totMb=(float)(strtol(tab[tot][value],&end,10)/1000);
    float freeMb=(float)(strtol(tab[free][value],&end,10)/1000);
    float availMb=(float)(strtol(tab[avail][value],&end,10)/1000);
    
    float swTotMb=(float)(strtol(tab[swTot][value],&end,10)/1000);
    float swFreeMb=(float)(strtol(tab[swFree][value],&end,10)/1000);

    // imprimir resultados
    fprintf(stdout,"i. Obtener la memoria ram total, libre y disponible en Megabytes (1E6 no MiB):\n");
    fprintf(stdout,"------------------------------------------------------------------------------\n");
    fprintf(stdout,"Memoria total: %.1f MB\n",totMb);
    fprintf(stdout,"Memoria libre: %.1f MB\n",freeMb);
    fprintf(stdout,"Memoria disponible: %.1f MB\n\n",availMb);  

    fprintf(stdout,"ii. Obtener la memoria swap Ocupada:\n");
    fprintf(stdout,"------------------------------------------------------------------------------\n");
    fprintf(stdout,"Swap ocupada: %.1f MB\n\n",swTotMb-swFreeMb);
    
    return 0;
}

// ------------------------------------------------------------------------------------------------------------------
// compilacion/ejecucion
// [clifferto@clifferto-sys 1-strings]$ gcc -Wall -Wextra -Werror -pedantic memTool.c --output bin/memTool
// [clifferto@clifferto-sys 1-strings]$ ./bin/memTool 
