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
short int valor_short_int;
char *valor_string;
}

%token OPLIST
%token P_A P_C
%token C_A C_C
%token PYC
%token SUMA RESTA MULT DIV ASIG
%token <valor_string>ID
%token <valor_short_int>CTE
%right ASIG
%left SUMA
%left RESTA
%left MULT
%left DIV

%type <valor_int> exp
%type <valor_int> factor
%type <valor_int> l
%type <valor_int> term
%type <valor_int> oplist

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
    OPLIST C_A o P_A ID PYC ID {$<valor_short_int>7;} P_C C_A l C_C C_C 
    {
        printf("R1: OPLIST -> oplist [ O ( id ; id ) [ L ] ] \n"); 
        
        printf("---------------LISTA A SUMAR=%d\n",$11);
        
        $7 = $11;

        if($7 >=-32768 && $7<=32767){
		        printf("---------------b=%d\n",$7);
		    }
        else{
				printf("El valor de b short int excede el limite permitido.\n");
        }
        
        
    }
    ;
l:
    exp {printf("R2: L -> EXP \n"); 
    $$ = $1;
    printf("---------------L=%d\n",$$);
    }
    | l PYC exp {printf("R3: L -> L ; EXP \n"); 
    $$ = $1 + $3;
    printf("---------------L=%d\n",$$);
    }
    ;
o:
    SUMA {printf("R4: O -> + \n"); }
    | MULT {printf("R5: O -> * \n"); }
    ;
exp:
    exp SUMA term  {printf("R6: EXP -> EXP + TERM \n"); 
    $$ = $1 + $3;
    printf("---------------EXP=%d\n",$$);
    }
    | term {printf("R7: EXP -> TERM \n"); 
    $$ = $1;
    printf("---------------EXP=%d\n",$$);
    }
    ;
term:
    term MULT factor {printf("R8: TERM -> TERM * FACTOR \n"); 
    $$ = $1 * $3;
    printf("---------------TERM=%d\n",$$);
    }
    | factor {printf("R9: TERM -> FACTOR \n"); 
    $$ = $1;
    printf("---------------TERM=%d\n",$$);
    }
    ;
factor:
    ID {printf("R10: FACTOR -> id (%s) \n", yylval.valor_string); 
        $$ = $<valor_string>1;
        printf("---------------FACTOR=%d\n",$$);
        }
    | CTE {printf("R11: FACTOR -> cte (%d) \n", yylval.valor_int); 
        $$ = $<valor_int>1;
        printf("---------------FACTOR=%d\n",$$);
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