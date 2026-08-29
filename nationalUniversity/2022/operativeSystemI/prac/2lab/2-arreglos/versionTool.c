// obtener numero de lineas, palabras y caracteres 

// [clifferto@clifferto-sys 2-arreglos]$ wc --lines --words --chars /proc/version 
// 1 22 157 /proc/version

// Tenemos una linea, por lo que con un fgets() bastaria.
// Y son 157 caracteres por lo que para crear el arreglo dinamico
// hay que buscar una forma de calcularlos dentro de C.

// ------------------------------------------------------------------------------------------------------------------

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// ------------------------------------------------------------------------------------------------------------------
// NADA DE ESTO FUNCIONA SI EL ARCHIVO ESTA EN /proc
// ------------------------------------------------------------------------------------------------------------------
// #include <sys/stat.h>

// // calcular el tamaño del archivo (cant de caracteres)
// struct stat filestt;
// stat("/proc/version",&filestt);

// fseek(version,0,SEEK_END);
// long int sz=ftell(version);
// fseek(version,0,SEEK_SET);

// ------------------------------------------------------------------------------------------------------------------
// descriptor del array dinamico
typedef struct{
    int size;
    char *ptr;
}DArray;

int main(){    
    
    // abrir archivo para leer
    FILE *version=fopen("/proc/version","r");
    if(version==NULL){
        printf("No se pudo leer el archivo.");   
        return -1;
    }

    // calcular tamaño mediante lectura
    int sz=0;

    while(!feof(version)){
        fgetc(version);
        sz++;
    }

    // instanciar array dinamico
    DArray buff={
        // retornar la posicion del EOF
        buff.size=sz,
        // alocar size posiciones de memoria para dato char
        buff.ptr=(char*)malloc(sz)
    };    

    // volver puntero al inicio
    fseek(version,0,SEEK_SET);

    // para todo el archivo
    while(!feof(version)){
        
        // leer toda la linea 
        fgets(buff.ptr,buff.size,version);
    }

    // cerrar archivo
    fclose(version);

    // imprimir original
    printf("Original:\n%s",buff.ptr);
    
    /**
     * para cada caracter, pasar a mayusculas las letras en minuscula que existan.    
     * MAYUSCULAS ASCII: si char entre 97 y 122 restar 32 para hacer mayuscula. 
     */    
    printf("\nIniciando conversion...\n");
    for(int cc;cc<buff.size;cc++){
        
        // pasar a entero para detectar
        int char2int=(int)(*(buff.ptr+cc));

        // detectar letra minuscula
        if(char2int>=97 && char2int<=122){
            
            // imprmir el proceso
            char lower=(char)(char2int);
            char upper=(char)(char2int-32);
            printf("%c --> %c, ",lower,upper);

            // reemplazar por mayuscula
            *(buff.ptr+cc)=upper;
        } 
    }     
    printf("\nFinalizo conversion\n");
    for(int ss=0;ss<(int)strlen("Finalizo conversion\n");ss++) putc('-',stdout);
    printf("\n\n");
    
    // mostrar resultados
    printf("Lea el archivo /proc/version y copie las palabras en un arreglo dinámico. Luego:\n");
    printf("\ti. Imprima la lista de palabras en mayúscula.\n");
    printf("\tii. Libere la memoria que haya alocado.\n\n");

    printf("%s\n",buff.ptr);  

    // liberar memoria
    free(buff.ptr);  
    
    return 0;   
}

// ------------------------------------------------------------------------------------------------------------------
// compilacion/ejecucion
// [clifferto@clifferto-sys 2-arreglos]$ gcc -Wall -Wextra -Werror -pedantic versionTool.c --output bin/versionTool
// [clifferto@clifferto-sys 2-arreglos]$ ./bin/versionTool 