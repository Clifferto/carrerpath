#include "llappend.h"

#include <stdlib.h>
#include <string.h>

/**
 * @brief Agrega un nodo al final de la linkedList.
 * Mediante la info en el descriptor de la linked list 
 * accede directamente al ultimo elementro (forma rapida).
 * 
 * @param ll Descriptor de la linkedList
 * @return int 
 */
int appendFast(Node *new,LList *ll){
    
    // si es el primer elemento
    if(ll->head==ll->tail) ll->head->next=new;
    else ll->tail->next=new;

    // agregarlo como ultimo elemento
    ll->tail=new;    

    return 0;
}

/**
 * @brief Agrega un nodo al final de la linkedList.
 * Recorre toda la lista para encontrar el ultimo nodo (forma lenta).
 * 
 * @param new Puntero al nuevo nodo.
 * @param head Puntero al primer nodo de la linkedList.
 * @return int 
 */
int appendSlow(Node *new,Node *head){

    // encontrar ultimo nodo de la lista
    Node *tail=head;

    // mientras que next!=NULL, apuntar al siguiente
    while(tail->next!=NULL){
        tail=tail->next;
    } 

    // linkear nuevo nodo al final
    tail->next=new;

    return 0;
}

