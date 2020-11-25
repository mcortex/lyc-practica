#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "arbol.h"

/** Crea un Nodo apuntando a dos Hojas*/
tNodo* crearNodo(const char* dato, tNodo *pIzq, tNodo *pDer){
    
    tNodo* nodo = malloc(sizeof(tNodo));   
    tInfo info;
    strcpy(info.dato, dato);
    nodo->info = info;
    nodo->izq = pIzq;
    nodo->der = pDer;

    return nodo;
}

/** Crea Nodo Hoja*/
tNodo* crearHoja(char* dato){	
    tNodo* nodoNuevo = (tNodo*)malloc(sizeof(tNodo));

	strcpy(nodoNuevo->info.dato, dato);
    nodoNuevo->izq = NULL;
    nodoNuevo->der = NULL;

    return nodoNuevo;
}

/** in order*/
void enOrden(tArbol *p)
{
    if (*p)
    {
        enOrden(&(*p)->izq);
        verNodo((*p)->info.dato);
        enOrden(&(*p)->der);
    }
}
/** pre order*/
void preOrden(tArbol *p)
{
    if (*p)
    {
        verNodo((*p)->info.dato);
        enOrden(&(*p)->izq);
        enOrden(&(*p)->der);
    }
}
/** post order*/
void postOrden(tArbol *p)
{
    if (*p)
    {
        postOrden(&(*p)->izq);
        postOrden(&(*p)->der);
		verNodo((*p)->info.dato);		
    }
}
/** Muestra contenido del nodo*/
void verNodo(const char *p)
{
    printf("%s ", p);
}

/**Funciones de graphViz*/

void _tree_print_dot_subtree(int nro_padre, tNodo *padre, int nro, tArbol *nodo, FILE* stream)
{
    if (*nodo != NULL)
    {    
		//verNodo((*p)->info.dato);
        //postOrden(&(*p)->izq);
        //postOrden(&(*p)->der);
        printf("x%d [label=<%s>];\n",nro,(*nodo)->info.dato);
        fprintf(stream, "x%d [label=<%s>];\n",nro,(*nodo)->info.dato);
        if (padre != NULL){
            fprintf(stream, "x%d -> x%d;\n",nro_padre,nro);
            //printf("padre: %d\n", nro_padre);
            printf("x%d -> x%d;\n",nro_padre,nro);
        }   
        _tree_print_dot_subtree(nro, *nodo, 2 * nro + 1, &(*nodo)->izq, stream);
        _tree_print_dot_subtree(nro, *nodo, 2 * nro + 2, &(*nodo)->der, stream);
        
    }
    /* else {
        fprintf(stream, "nil%d [label=nil,fontcolor=gray,shape=none];\n",nro);
        fprintf(stream, "x%d -> nil%d;\n",nro_padre,nro);
        printf("nil%d [label=nil,fontcolor=gray,shape=none];\n",nro);
        printf("x%d -> nil%d;\n",nro_padre,nro);
    } */
}

void tree_print_dot(tArbol *p,FILE* stream)
{
    fprintf(stream, "digraph BST {\n");
    // printf("dir p: %p \n",&(*p));
    // printf("p: %s \n",*p);
    if (*p)
        _tree_print_dot_subtree(-1, NULL, 0, &(*p), stream);
    fprintf(stream, "}");
}

/* static void _tree_print_dot_subtree(int parent_number, tree_node* parent, int number, tree_node* node)
{
    if (node != nullptr) {
        cout << "x" << number << " [label=<" << node->key << ">]" << ";" << endl;
        if (parent != nullptr)
            cout << "x" << parent_number << " -> " << "x" << number << ";" << endl;
        // dive into left and right subtree
        _tree_print_dot_subtree(number, node, 2 * number + 1, node->left);
        _tree_print_dot_subtree(number, node, 2 * number + 2, node->right);
    } else {
        cout << "nil" << number << " [label=nil,fontcolor=gray,shape=none]" << ";" << endl;
        cout << "x" << parent_number << " -> " << " nil" << number << ";" << endl;
    }
}

void tree_print_dot(tree_node* root)
{
    cout << "digraph tree1 {" << endl;
    if (root != nullptr)
        _tree_print_dot_subtree(-1, nullptr, 0, root);
    cout << "}" << endl;
} */