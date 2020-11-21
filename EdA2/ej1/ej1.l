%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;

%}
%option noyywrap  
%option yylineno 

DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO})*
CTE         {DIGITO}+
PYC         ";"
P_A         "("
P_C         ")"
C_A         "["
C_C         "]"
ASIG        ":="
SUMA        "+"
RESTA       "-"
MULT        "\*"
DIV         "\/"

%%
"oplist"        {printf("\tLEX: Palabra reservada oplist: %s \n", yytext);return OPLIST;}
{ID}            {printf("\tLEX: ID: %s \n", yytext); yylval.valor_string = strdup(yytext); return ID;}
{CTE}           {printf("\tLEX: CTE: %s \n", yytext);yylval.valor_int = atoi(yytext); return CTE;}
{PYC}           {printf("\tLEX: PYC: %s \n", yytext);return PYC;}
{P_A}           {printf("\tLEX: P_A: %s \n", yytext);return P_A;}
{P_C}           {printf("\tLEX: P_C: %s \n", yytext);return P_C;}
{C_A}           {printf("\tLEX: C_A: %s \n", yytext);return C_A;}
{C_C}           {printf("\tLEX: C_C: %s \n", yytext);return C_C;}
{SUMA}          {printf("\tLEX: SUMA: %s \n", yytext);return SUMA;}
{RESTA}         {printf("\tLEX: RESTA: %s \n", yytext);return RESTA;}
{MULT}          {printf("\tLEX: MULT: %s \n", yytext);return MULT;}
{DIV}           {printf("\tLEX: DIV: %s \n", yytext);return DIV;}
{ASIG}          {printf("\tLEX: ASIG: %s \n", yytext);return ASIG;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%


/*
EJEMPLO:
oplist [+ (a;b)[2*c+d;3;5+c]] // b=a+(2*c+d)+3+(5+c)
*/

/*
int main(int argc,char *argv[]) {
    if ((yyin = fopen(argv[1], "rt")) == NULL){
        printf("No se puede abrir el archivo: %s n", argv[1]);
    }
    else {
        yylex();
    }
    fclose(yyin);
}

int yyerror(void) {
    printf("Error Lexico\n");
    system("Pause");
    exit(1);
}
*/