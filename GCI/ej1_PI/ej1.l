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
CONST_INT     {DIGITO}+
P_A         "("
P_C         ")"
ASIG        ":="
SUMA        "+"
RESTA       "-"
MULT        "\*"
DIV         "\/"
COMA        ","

%%
"prom"           {printf("\tLEX: PROM: %s \n", yytext);return PROM;}
{ID}            {printf("\tLEX: ID: %s \n", yytext); yylval.valor_string = strdup(yytext); return ID;}
{CONST_INT}     {printf("\tLEX: CONST_INT: %s \n", yytext);yylval.valor_int = atoi(yytext); return CONST_INT;}
{P_A}           {printf("\tLEX: P_A: %s \n", yytext);return P_A;}
{P_C}           {printf("\tLEX: P_C: %s \n", yytext);return P_C;}
{SUMA}          {printf("\tLEX: SUMA: %s \n", yytext);return SUMA;}
{RESTA}         {printf("\tLEX: RESTA: %s \n", yytext);return RESTA;}
{MULT}          {printf("\tLEX: MULT: %s \n", yytext);return MULT;}
{DIV}           {printf("\tLEX: DIV: %s \n", yytext);return DIV;}
{ASIG}          {printf("\tLEX: ASIG: %s \n", yytext);return ASIG;}
{COMA}          {printf("\tLEX: COMA: %s \n", yytext);return COMA;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%