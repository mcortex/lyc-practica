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
char *valor_string;
}

%token <valor_string>ID
%token FIN
%token COMA
%token ASIG
%token EXP
/*%right ASIG*/

%%
p0:
    p {printf("R0 \n"); }
    ;
p:
    {printf("**Inicia COMPILACION**\n"); } 
    l e FIN {printf("R1: P -> L E fin \n"); }
    {printf("**Fin COMPILACION ok**\n"); }
    ;
l:
    l COMA ID {printf("R2: L -> L , id \n"); }
    | ID {printf("R3: L -> id \n"); }
    ;
e:
    ASIG EXP {printf("R4: E -> := exp \n"); }
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