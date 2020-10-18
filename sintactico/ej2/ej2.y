%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
%}


%token P_A P_C


%%
s0:
    {printf("**Inicia COMPILACION**\n"); } 
    s {printf("R0 \n"); }
    {printf("**Fin COMPILACION ok**\n"); }
    ;
s:
    P_A l P_C {printf("R1: S -> ( L ) \n"); }
    | P_A P_C {printf("R2: S -> ( ) \n"); }
    ;
l:
    P_A l P_C {printf("R3: L -> ( L ) \n"); }
    | l P_A P_C {printf("R4: L -> L ( ) \n"); }
    | P_A P_C {printf("R5: L -> ( ) \n"); }
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