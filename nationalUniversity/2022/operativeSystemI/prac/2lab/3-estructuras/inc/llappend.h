
// descriptor de un nodo de la lista
struct node{
    char data[100];
    // int data;
    struct node *next;
};
typedef struct node Node;

// descriptor de la llist
typedef struct{
    Node *head;
    Node *tail;
}LList;

/**
 * @brief Agrega un nodo al final de la linkedList.
 * Mediante la info en el descriptor de la linked list 
 * accede directamente al ultimo elementro (forma rapida).
 * 
 * @param ll Descriptor de la linkedList
 * @return int 
 */
int appendFast(Node *new,LList *ll);

/**
 * @brief Agrega un nodo al final de la linkedList.
 * Recorre toda la lista para encontrar el ultimo nodo (forma lenta).
 * 
 * @param new Puntero al nuevo nodo.
 * @param head Puntero al primer nodo de la linkedList.
 * @return int 
 */
int appendSlow(Node *new,Node *head);