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

%token IF THEN ELSE
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
programa:
    {printf("**Inicia COMPILADOR**\n"); } 
    sel {printf("0. S -> SEL \n"); }
    {printf("**Fin COMPILADOR ok**\n"); }
    ;

sel:
    ID ASIG if {printf("1. A -> id := P\n"); }
    ;

if:
    IF cond THEN expresion ELSE expresion {printf("2. IF -> if COND then E else E \n"); }
    ;

cond:
    ID MAY CTE {printf("3. COND -> id may cte \n"); }
    | ID MEN CTE {printf("4. COND -> id men cte \n"); }
    ;

expresion:
    expresion SUMA termino  {printf("5. E -> E + T \n"); }
    | termino {printf("6. E -> T \n"); }
    ;
termino:
    termino MULT factor {printf("7. T -> T * F \n"); }
    | factor {printf("8. T -> F \n"); }
    ;
factor:
    ID {printf("9. F -> id (%s) \n", yylval.valor_string); }
    | CTE {printf("10. F -> cte(%d) \n", yylval.valor_int); }
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