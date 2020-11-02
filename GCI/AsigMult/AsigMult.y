%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
#include "arbol.c"

FILE *fp;
FILE *graph;
char str_aux[50];
int yylex();

int yystopparser=0;
FILE *yyin;
%}

%union {
int valor_int;
char *valor_string;
}

%token <valor_string>ID
%token <valor_int>CTE
%token ASIG
%left ASIG


%%
s:
    {
    fprintf(fp,"**Inicia COMPILADOR**\n"); } 
    mult {
        sPtr = multPtr; fprintf(fp,"0. S -> MULT. \n"); 
        postOrden(&sPtr);
        //bst_print_dot(&sPtr,graph);
        tree_print_dot(&sPtr,graph);
        }
    
    {fprintf(fp,"**Fin COMPILADOR ok**\n"); }
    ;

mult:
    lista CTE {
              sprintf(str_aux, "%d",$2); 
              multPtr = crearNodo("S", crearNodo("ASIG", crearHoja("aux"), crearHoja(str_aux)), listaPtr);
              //multPtr = crearNodo("S", crearNodo("ASIG", crearHoja("aux"), crearHoja("CTE")), listaPtr);
              fprintf(fp,"1. MULT -> LISTA cte.\n"); 
              }
    ;

lista:
    lista ID ASIG {
                  listaPtr = crearNodo("S", listaPtr, crearNodo("ASIG", crearHoja($2), crearHoja("aux")));
                  //listaPtr = crearNodo("S", listaPtr, crearNodo("ASIG", crearHoja("ID"), crearHoja("aux")));
                  fprintf(fp,"2. LISTA -> LISTA id asigna. \n");
                  }
    | ID ASIG {
              listaPtr = crearNodo("ASIG", crearHoja($1), crearHoja("aux"));
              //listaPtr = crearNodo("ASIG", crearHoja("ID"), crearHoja("aux"));
              fprintf(fp,"3. LISTA -> id asigna. \n"); 
              }
    ;

%%

int main(int argc,char *argv[])
{
  fp = fopen("reglas.txt","w"); 
  if (!fp)
    printf("\nNo se puede abrir el archivo reglas.txt \n");

  graph = fopen("graph.dot","w"); 
  if (!graph)
     printf("\nNo se puede abrir el archivo \n");

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  fclose(yyin);
  }

  fclose(fp);
  fclose(graph);

  return 0;
}
int yyerror(void)
{
	fprintf(fp,"Syntax Error\n");
	//system ("Pause");
	exit (1);
}