#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>

#include "./inc/tools.h"

// controller
int main(int argc, char const *argv[]){

    // chequar cantidad de parametros    
    assert(!(argc<3) && "Too few parameters error");

    // model
    int a=atoi(argv[1]);
    int b=atoi(argv[2]);
    int res=opp(a,b);

    // view
    printf("Programa\n");    
    for(int ii=0;argv[ii]!=(char*)NULL;ii++) printf("ARG: %s\n",argv[ii]);
    
    printf("%s %d\n",msj(),res);

    return 0;
}
