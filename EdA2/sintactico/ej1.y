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
oplist [+ (a;b)[2*c+d;3;5+c]] // b=a+(2*c+d)+3+(5+c)

*/

s: 
    {printf("**Inicia COMPILADOR**\n"); } 
    oplist {printf("R0: S -> OPLIST \n"); }
    {printf("**Fin COMPILADOR ok**\n"); }
    ;
oplist:
    OPLIST C_A o P_A ID PYC ID P_C C_A l C_C C_C 
    {printf("R1: OPLIST -> oplist [ O ( id ; id ) [ L ] ] \n"); }
    ;
l:
    exp {printf("R2: L -> EXP \n"); }
    | l PYC exp {printf("R3: L -> L ; EXP \n"); }
    ;
o:
    SUMA {printf("R4: O -> + \n"); }
    | MULT {printf("R5: O -> * \n"); }
    ;
exp:
    exp SUMA term  {printf("R6: EXP -> EXP + TERM \n"); }
    | term {printf("R7: EXP -> TERM \n"); }
    ;
term:
    term MULT factor {printf("R8: TERM -> TERM * FACTOR \n"); }
    | factor {printf("R9: TERM -> FACTOR \n"); }
    ;
factor:
    ID {printf("R10: FACTOR -> id (%s) \n", yylval.valor_string); }
    | CTE {printf("R11: FACTOR -> cte (%d) \n", yylval.valor_int); }
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