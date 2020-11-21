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

%token OPLIST
%token P_A P_C
%token C_A C_C
%token PYC
%token SUMA RESTA MULT DIV ASIG
%token <valor_string>ID
%token <valor_int>CTE
%right ASIG
%left SUMA
%left RESTA
%left MULT
%left DIV

%%
/*
S -> OPLIST
OPLIST -> oplist [ O ( id ; id ) [ L ] ]
L -> EXP
L -> L ; EXP
O -> +
O -> *
EXP -> EXP + TERM
EXP -> TERM
TERM -> TERM * FACTOR
TERM -> FACTOR
FACTOR -> id
FACTOR -> cte

EJEMPLO:
oplist [+ (a;b)[w+7*3*x+11*y;3;z+a]] // b=a+(w+7*3*x+11*y)+3+(z+a)

*/

s: 
    {fprintf(fp,"**Inicia COMPILADOR**\n"); } 
    oplist 
    {
    sPtr = oplistPtr; 
    fprintf(fp,"0. S -> MULT. \n"); 
    postOrden(&sPtr); // Mostramos arbol
    printf("\n");
    tree_print_dot(&sPtr,graph); // Grafica arbol

    fprintf(fp,"R0: S -> OPLIST \n");
    fprintf(fp,"**Fin COMPILADOR ok**\n"); 
    }
    ;
oplist:
    OPLIST C_A o P_A ID PYC ID P_C C_A l C_C C_C 
    {
        oPtr = crearNodo(oPtr->info.dato, crearHoja($5), listaPtr);
        oplistPtr = crearNodo("=", crearHoja($7), oPtr);
        fprintf(fp,"R1: OPLIST -> oplist [ O ( id ; id ) [ L ] ] \n");
    }
    ;
l:
    exp {
        listaPtr = expPtr;
        fprintf(fp,"R2: L -> EXP \n");
        }
    | l PYC exp {                
                listaPtr = crearNodo(oPtr->info.dato, listaPtr, expPtr);
                oPtr = crearHoja(oPtr->info.dato); // Creamos otro nodo de operacion ya que usamos el anterior
                printf("valor de oPtr: %s\n",oPtr->info.dato);
                fprintf(fp,"R3: L -> L ; EXP \n");
                }
    ;
o:
    SUMA {
        oPtr = crearHoja("+");
        printf("valor de oPtr: %s\n",oPtr->info.dato);
        fprintf(fp,"R4: O -> + \n");
        }
    | MULT {
            oPtr = crearHoja("*");
            fprintf(fp,"R5: O -> * \n");
            }
    ;
exp:
    exp SUMA term  {
                    expPtr = crearNodo("+", expPtr, termPtr);
                    fprintf(fp,"R6: EXP -> EXP + TERM \n"); 
                    }
    | term  {
            expPtr = termPtr;
            fprintf(fp,"R7: EXP -> TERM \n");
            }
    ;
term:
    term MULT factor {
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