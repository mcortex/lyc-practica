%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
#include "arbol.c"

int yystopparser=0;
FILE *yyin;
FILE *fp;
FILE *graph;
char str_aux[50];
int yylex();
%}

%union {
int valor_int;
char *valor_string;
}

%token IF THEN ELSE ENDIF
%token P_A P_C
%token PYC
%token SUMA RESTA MULT DIV ASIG COMA
%token MAY MEN MAY_I MEN_I CMP_I CMP_D
%token <valor_string>ID
%token <valor_int>CTE
%token PROM
%right ASIG
%left SUMA
%left RESTA
%left MULT
%left DIV

%%
/*
start -> sel
sel -> IF cond THEN accion ENDIF 
cond -> ID < CTE  
accion -> ID := exp
exp  -> exp + term 
exp  -> term 
term -> term * factor
term -> factor
factor -> CTE
factor -> ID
*/

programa:
    {printf("**Inicia COMPILADOR**\n"); } 
    sel {
        sPtr = selPtr; 
        postOrden(&sPtr); // Mostramos arbol
        printf("\n");
        tree_print_dot(&sPtr,graph); // Grafica arbol
        fprintf(fp,"0. S -> SEL \n"); 
        printf("**Fin COMPILADOR ok**\n"); 
        }
    ;

sel:
    IF cond THEN accion {selPtr = crearNodo("IF",condPtr,accionPtr);}  ENDIF {fprintf(fp,"1. IF cond THEN accion ENDIF \n"); }
    | IF cond  
      THEN accion {thenPtr = accionPtr;}  
      ELSE accion {elsePtr = accionPtr;} ENDIF {
        cuerpoPtr = crearNodo("CUERPO",thenPtr,elsePtr);
        selPtr = crearNodo("IF",condPtr,cuerpoPtr);
        fprintf(fp,"2. IF cond THEN accion ELSE accion ENDIF  \n"); }
    ;

cond:
    ID comparador CTE {
      sprintf(str_aux, "%d",$3); 
      condPtr = crearNodo(compPtr->info.dato,crearHoja($1),crearHoja(str_aux));
      fprintf(fp,"3. cond -> id comparador cte \n");
    }
    ;

comparador:
          MAY { compPtr = crearHoja("MAY"); 
              printf("valor de compPtr: %s\n",compPtr->info.dato);
              fprintf(fp,"R4: comparador -> > \n");
              }
          |MEN { compPtr = crearHoja("MEN"); 
              printf("valor de compPtr: %s\n",compPtr->info.dato);
              fprintf(fp,"R4: comparador -> < \n");
              }
          |MAY_I { compPtr = crearHoja("MAY_I"); 
              printf("valor de compPtr: %s\n",compPtr->info.dato);
              fprintf(fp,"R4: comparador -> >= \n");
              }
          |MEN_I { compPtr = crearHoja("MEN_I"); 
              printf("valor de compPtr: %s\n",compPtr->info.dato);
              fprintf(fp,"R4: comparador -> <= \n");
              }
          |CMP_D { compPtr = crearHoja("CMP_D"); 
              printf("valor de compPtr: %s\n",compPtr->info.dato);
              fprintf(fp,"R4: comparador -> != \n");
              }
          |CMP_I { compPtr = crearHoja("CMP_I"); 
              printf("valor de compPtr: %s\n",compPtr->info.dato);
              fprintf(fp,"R4: comparador -> == \n");
              }
          ;

accion:
        ID ASIG expresion {
          printf("5. accion -> ID := exp \n"); 
          accionPtr = crearNodo(":=",crearHoja($1), expPtr) ; 
        } 
        ;

expresion:
    expresion SUMA termino  {
                    expPtr = crearNodo("+", expPtr, termPtr);
                    fprintf(fp,"R6: EXP -> EXP + TERM \n"); 
                    }
    | termino {
            expPtr = termPtr;
            fprintf(fp,"R7: EXP -> TERM \n");
            }
    ;
termino:
    termino MULT factor {
                    termPtr = crearNodo("*", termPtr, factPtr);
                    fprintf(fp,"R8: TERM -> TERM * FACTOR \n");
                    }
    | factor {
            termPtr = factPtr;
            fprintf(fp,"R9: TERM -> FACTOR \n");
            }
    ;
factor:
    ID {
      factPtr = crearHoja($1);
      fprintf(fp,"R10: FACTOR -> id (%s) \n", yylval.valor_string); 
      }
    | CTE {
      sprintf(str_aux, "%d",$1); 
      factPtr = crearHoja(str_aux);
      fprintf(fp,"R11: FACTOR -> cte (%d) \n", yylval.valor_int);
      }
    ;

%%

int main(int argc,char *argv[])
{

    fp = fopen("reglas.txt","w"); 
    if (!fp)
    {
        printf("\nNo se puede abrir el archivo reglas.txt \n");
    }

    graph = fopen("graph.dot","w"); 
    if (!graph)
    {
        printf("\nNo se puede abrir el archivo \n");
    }
    

    if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
	    printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }
    else
    {
	    yyparse();
    }
    fclose(yyin);
    return 0;
}

int yyerror(void)
{
	printf("Syntax Error\n");
	//system ("Pause");
	exit (1);
}