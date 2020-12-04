#ifndef FUNCIONES_H
#define FUNCIONES_H

enum tipoError
{
    ErrorSintactico,
    ErrorLexico
};
/* Tipos de datos para la tabla de simbolos */
#define Integer 1
#define Float 2
#define String 3
#define CteInt 4
#define CteFloat 5
#define CteString 6
#define SinTipo 7
#define SIN_MEM -4
#define NODO_OK -3
#define TRUE 1
#define FALSE 0

#define TAMANIO_TABLA 300
#define TAM_NOMBRE 52
#define ES_CTE_CON_NOMBRE 1


typedef struct {
		char nombre[TAM_NOMBRE];
		int tipo_dato;
		char valor_s[TAM_NOMBRE];
		float valor_f;
		int valor_i;
		int longitud;
		int esCteConNombre;
} TS_Reg;

TS_Reg tabla_simbolo[TAMANIO_TABLA];

// -------------------- POLACA INVERSA
typedef struct {
	char dato[100];
    // char tipo_dato[10];
	int tipo_dato;
    int posicion;
}tInfo;

typedef struct {
    tInfo celda;
}polaca;

// struct polaca polaca_inversa[1000];
polaca polaca_inversa[1000];

// --- FUNCIONES PI
void insertaEnPolaca(char *, int );
void muestraPolaca();
void grabarPolaca();
void avanzar();
void escribirEnCeldaX(int);
void escribirEnCeldaXMasUno(int);

// --- FUNCIONES TS
void mensajeDeError(enum tipoError error,const char* info, int linea);
void agregarVarATabla(char* nombre,int esCteConNombre,int linea);
void agregarTiposDatosATabla(void);
void agregarCteATabla(int num);
void agregarString(char *);
int chequearVarEnTabla(char* nombre,int linea);
int verificarCompatible(int tipo,int tipoAux);
int buscarEnTabla(char * nombre);
void grabarTabla(void);
char* normalizarNombre(const char* nombre);
char* reemplazarCaracter(char* aux);
char* normalizarId(const char* cadena);
void validarCteEnTabla(char* nombre,int linea);
void agregarValorACte(int tipo);
void insertaMensaje (char * mensaje);
void insertarEntero(int numero);

// int verificarTipoDato(tArbol * p,int linea);
// void verificarTipo(tArbol* p,int tipoAux,int linea);

// void generarAsm(tArbol *p); // modificar
// void recorrerArbol(tArbol *arbol,FILE * pf);// modificar
// void tratarNodo(tArbol* nodo,FILE *pf);// modificar

void generarAsm();
void recorrerPolaca(FILE *);
void tratarCelda(tInfo *, FILE *);


struct m10_stack_entry {
  tInfo *dato;
  struct m10_stack_entry *next;
};

struct m10_stack_t
{
  struct m10_stack_entry *tope;
  size_t tam; 
};

struct m10_stack_t *crearPila(void);
tInfo *copiarDato(tInfo *);
void ponerenPila(struct m10_stack_t *, tInfo *value);
tInfo *topedePila(struct m10_stack_t *);
void sacardePila(struct m10_stack_t *);
void vaciarPila(struct m10_stack_t *);
void borrarPila(struct m10_stack_t **);
typedef struct m10_stack_t m10_stack_t;

tInfo * auxPtr;
tInfo * auxPtr2;

#endif