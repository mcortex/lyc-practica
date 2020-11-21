%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
int yylex();

int OPi=0,
    Ai=0,
    Bi=0,
    Ci=0,
    Li=0,
    Oi=0,
    Ei=0,
    Ti=0,
    Fi=0;

char str_aux[50];
char str_Oi[50];
char str_Ai[50];
char str_Li[50];
char str_Bi[50];
char str_Ci[50];
char str_Ei[50];
char str_Ti[50];
char str_Fi[50];

typedef struct {
	char dato[50];
}tInfo;

struct terceto{
    tInfo dato1;
    tInfo dato2;
    tInfo dato3;
};

struct terceto matTerceto[100];

int posicion=0;

int creaTer(char *,char *,char *);
void muestraTercetos();

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
    {
    printf("**Fin COMPILADOR ok**\n"); 
    muestraTercetos();
    }
    ;
oplist:
    OPLIST C_A o P_A 
        ID {
            Ai = creaTer($5," "," ");
            printf("Ai=%d\n",Ai);
            } 
    PYC 
        ID {
            Bi = creaTer($8," "," ");
            printf("Bi=%d\n",Bi);
            } 
    P_C C_A l C_C C_C 
    {
        printf("R1: OPLIST -> oplist [ O ( id ; id ) [ L ] ] \n");
        sprintf(str_Oi, "[%d]",Oi);
        sprintf(str_Ai, "[%d]",Ai);
        sprintf(str_Li, "[%d]",Li);
        Ci = creaTer(str_Oi,str_Ai,str_Li);
        printf("Ci=%d\n",Ci);
        sprintf(str_Bi, "[%d]",Bi);
        sprintf(str_Ci, "[%d]",Ci);
        OPi = creaTer("=",str_Bi,str_Ci);
        printf("OPi=%d\n",OPi);
    }
    ;
l:
    exp {
        printf("R2: L -> EXP \n"); 
        Li=Ei;
        printf("Oi=%d\n",Oi);
        }
    | l PYC exp {
                printf("R3: L -> L ; EXP \n");
                sprintf(str_Oi, "[%d]",Oi);
                sprintf(str_Li, "[%d]",Li);
                sprintf(str_Ei, "[%d]",Ei); 
                Li = creaTer(str_Oi,str_Li,str_Ei);
                printf("Li=%d\n",Li);
                }
    ;
o:
    SUMA {
        printf("R4: O -> + \n"); 
        Oi=creaTer("+"," "," ");
        printf("Oi=%d\n",Oi);
        }
    | MULT {
            printf("R5: O -> * \n"); 
            Oi=creaTer("*"," "," ");
            printf("Oi=%d\n",Oi);
            }
    ;
exp:
    exp SUMA term  {
                    printf("R6: EXP -> EXP + TERM \n"); 
                    sprintf(str_Ei, "[%d]",Ei);
                    sprintf(str_Ti, "[%d]",Ti);
                    Ei = creaTer("+",str_Ei,str_Ti);
                    printf("Ei=%d\n",Ei);
                    }
    | term {
            printf("R7: EXP -> TERM \n");
            Ei=Ti; 
            printf("Ei=%d\n",Ei);
            }
    ;
term:
    term MULT factor {
                    printf("R8: TERM -> TERM * FACTOR \n");
                    sprintf(str_Ti, "[%d]",Ti);
                    sprintf(str_Fi, "[%d]",Fi);
                    Ti = creaTer("*",str_Ti,str_Fi);
                    printf("Ti=%d\n",Ti);
                    }
    | factor  {
            printf("R9: TERM -> FACTOR \n"); 
            Ti = Fi;
            printf("Ti=%d\n",Ti);
            }
    ;
factor:
    ID {
        printf("R10: FACTOR -> id (%s) \n", yylval.valor_string); 
        Fi=creaTer($1," "," "); 
        printf("Fi=%d\n",Fi);
        }
    | CTE {
        printf("R11: FACTOR -> cte (%d) \n", yylval.valor_int);
        sprintf(str_aux, "%d",$1);
        Fi=creaTer(str_aux," "," "); 
        printf("Fi=%d\n",Fi);
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

int creaTer(char *cero,char *uno, char *dos) {
    strcpy(matTerceto[posicion].dato1.dato,cero);
    strcpy(matTerceto[posicion].dato2.dato,uno);
    strcpy(matTerceto[posicion].dato3.dato,dos);
    
    return posicion++;
}

void muestraTercetos() {
    int i=0;
    
    for (i=0;i<posicion;i++) {
        printf("[%d] ( %s , %s , %s )\n",i,matTerceto[i].dato1.dato,matTerceto[i].dato2.dato,matTerceto[i].dato3.dato);
    }
}