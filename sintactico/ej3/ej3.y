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
programa:
    {printf("**Inicia COMPILADOR**\n"); } 
    sentencia {printf("0. S' -> S \n"); }
    {printf("**Fin COMPILADOR ok**\n"); }
    ;

sentencia:
    ID ASIG expresion {printf("1. S -> id := E\n"); }
    ;
expresion:
    expresion SUMA termino  {printf("2. E -> E + T \n"); }
    | expresion RESTA termino {printf("3. E -> E - T \n"); }
    | termino {printf("4. E -> T \n"); }
    ;
termino:
    termino MULT factor {printf("5. T -> T * F \n"); }
    | termino DIV factor {printf("6. E -> T / F \n"); }
    | factor {printf("7. T -> F \n"); }
    ;
factor:
    P_A expresion P_C {printf("10. F -> ( E ) \n"); }
    | ID {printf("8. F -> id (%s) \n", yylval.valor_string); }
    | CONST_INT {printf("9. F -> cte(%d) \n", yylval.valor_int); }
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