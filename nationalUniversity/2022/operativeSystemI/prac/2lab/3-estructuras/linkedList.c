#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include "inc/llappend.h"

// bandera para seleccionar la funcion para agregar nodos
bool fUseFast=false;

int main(){

    // instanciar llist
    LList linkedList;
    
    // si esta vacia entonces head==tail
    linkedList.head=(Node*)malloc(sizeof(Node));
    linkedList.tail=linkedList.head;

    // agregar nodos
    for(int i=0;i<5;i++){
        
        // crear nuevo nodo 
        Node *new=malloc(sizeof(Node)); 
        
        // cargar dato y poner next en NULL
        sprintf(new->data,"Data: %d",i);
        new->next=(Node*)NULL;
        
        // agregar nodo
        if(fUseFast) appendFast(new,&linkedList);
        else appendSlow(new,linkedList.head);
    }

    // imprimir los datos
    Node *tmp=linkedList.head;
    
    while(true){
        
        printf("%s\n",tmp->data);
        tmp=tmp->next;
        
        if(tmp==NULL) break;
    }

    // no error
    return 0;
}