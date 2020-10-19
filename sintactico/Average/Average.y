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

%token P_A P_C
%token COMA
%token ASIG
%token AVG
%token <valor_string>ID
%token <valor_int>CONST_INT

%%
programa:
    {printf("**Inicia COMPILACION**\n"); } 
    s {printf("0. S' -> S \n"); }
    {printf("**Fin COMPILACION: OK**\n"); }
    ;

s:
    prom {printf("1. S -> PROM\n"); }
    ;
prom:
    ID ASIG AVG P_A l P_C  {printf("2. PROM -> id asig avg para L parc \n"); }
    ;
l:
    f {printf("3. L -> F \n"); }
    | l COMA f {printf("4. L -> L coma F \n"); }
    ;
f:
    ID {printf("5. F -> id (%s) \n", yylval.valor_string); }
    | CONST_INT {printf("6. F -> cte (%d) \n", yylval.valor_int); }
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