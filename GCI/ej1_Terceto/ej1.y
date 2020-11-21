%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
#include "Pila.c"

FILE *fp;
char str_aux[50];
int yylex();
int cont=0;


st *pila;


int yystopparser=0;
FILE  *yyin;
%}

%union {
int valor_int;
char *valor_string;
}

%token P_A P_C
%token PYC
%token SUMA RESTA MULT DIV ASIG COMA
%token <valor_string>ID
%token <valor_int>CONST_INT
%token PROM
%right ASIG
%left SUMA
%left RESTA
%left MULT
%left DIV

%%
programa:
    {
    printf("**Inicia COMPILADOR**\n");
    pila = createEmptyStack();
    } 
    a {printf("0. A' -> A \n"); }
    {
    printf("**Fin COMPILADOR ok**\n"); 
    printStack(pila);
    }
    ;

a:
    ID ASIG p {
                printf("1. A -> id := P\n"); 
                push(pila,$1);
                push(pila,":=");
                }
    ;

p:
    PROM P_A l P_C  {
                    printf("2. P -> prom para L parc \n");
                    sprintf(str_aux, "%d",cont); 
                    push(pila,str_aux);
                    push(pila,"/");
                    }
    ;

l:
    l COMA expresion {
                        printf("3. L -> L coma E \n");
                        Ei=crea_terceto("+",Li,Ei);
                        cont++;
                        }
    | expresion {
                printf("4. L -> E \n");
                Li=Ei;
                cont=1;
                }
    ;

expresion:
    expresion SUMA termino  {
                            printf("5. E -> E + T \n");
                            Ei=crea_terceto("+",Ei,Ti);
                            }
    | expresion RESTA termino {
                                printf("6. E -> E - T \n");
                                Ei=crea_terceto("-",Ei,Ti);
                                }
    | termino {
                printf("7. E -> T \n"); 
                Ei=Ti;
                }
    ;
termino:
    termino MULT factor {
                        printf("8. T -> T * F \n");
                        Fi=crea_terceto("*",Ti,Fi);
                        }
    | termino DIV factor {
                            printf("9. E -> T / F \n");
                            Fi=crea_terceto("/",Ti,Fi);
                            }
    | factor {
            printf("10. T -> F \n"); 
            Ti=Fi;
            }
    ;
factor:
    P_A expresion P_C {printf("13. F -> ( E ) \n"); }
    | ID {
        printf("11. F -> id (%s) \n", yylval.valor_string);
        Fi=crea_terceto($1,"","");
        }
    | CONST_INT {
                printf("12. F -> cte(%d) \n", yylval.valor_int);
                sprintf(str_aux, "%d",$1); 
                Fi=crea_terceto($1,"","");
                }
    ;
%%

int main(int argc,char *argv[])
{
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