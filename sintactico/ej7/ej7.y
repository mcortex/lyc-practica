%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
%}

%union {
int valor_int;
char *valor_string;
}

%token INICIO FIN
%token P_A P_C
%token PYC
%token SUMA RESTA MULT DIV ASIG
%token <valor_string>ID
%token <valor_int>CONST_INT
%right ASIG
%left SUMA
%left RESTA
%left MULT
%left DIV

%%
prog: 
    programa
    ;
programa:
    {printf("**Inicia COMPILADOR**\n"); } 
    INICIO bloque FIN
    {printf("**Fin COMPILADOR ok**\n"); }
    ;
bloque:
    sentencia {printf("R1: bloque -> sentencia \n"); }
    | bloque sentencia {printf("R2: bloque -> bloque sentencia \n"); }
    ;
sentencia:
    asignacion PYC {printf("R3: sentencia -> asignacion PYC \n"); }
    ;
asignacion:
    ID ASIG asignacion {printf("R4: asignacion -> ID ASIG asignacion \n"); }
    | ID ASIG expresion {printf("R5: asignacion -> ID ASIG expresion \n"); }
    ;
expresion:
    expresion SUMA termino  {printf("R6: expresion -> expresion SUMA termino \n"); }
    | expresion RESTA termino {printf("R7: expresion -> expresion RESTA termino \n"); }
    | termino {printf("R8: expresion -> termino \n"); }
    ;
termino:
    termino MULT factor {printf("R9: termino -> termino MULT factor \n"); }
    | termino DIV factor {printf("R10: termino -> termino DIV factor \n"); }
    | factor {printf("R11: termino -> factor \n"); }
    ;
factor:
    P_A expresion P_C {printf("R12: factor -> P_A expresion P_C \n"); }
    | ID {printf("R13: factor -> ID (%s) \n", yylval.valor_string); }
    | CONST_INT {printf("R14: factor -> CONST_INT(%d) \n", yylval.valor_int); }
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