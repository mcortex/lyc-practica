#ifndef FUNCIONES_H
#define FUNCIONES_H

/* Defino estructura de informacion para el arbol*/
typedef struct {
	char dato[40];
}tInfo;

/* Defino estructura de nodo de arbol  |izq|info|der| */
typedef struct sNodo{
	tInfo info;
	struct sNodo *izq, *der;
}tNodo;

/* Defino estructura de arbol*/
typedef tNodo *tArbol;
//tInfo infoArbol;

tNodo *crearNodo(const char *dato, tNodo *pIzq, tNodo *pDer);
tNodo *crearHoja(char *dato);

void enOrden(tArbol *p);
void preOrden(tArbol *p);
void postOrden(tArbol *p);
void verNodo(const char *p);

/* Declaraciones globales de punteros de elementos no terminales para el arbol de sentencias basicas*/

tArbol 	sPtr,			//Puntero de sentencia
		multPtr,		//Puntero de asignaciones multiples
		listaPtr;		//Puntero de lista de asignaciones
#endif