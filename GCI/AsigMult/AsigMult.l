%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "arbol.h"
FILE  *yyin;

%}
%option noyywrap  
%option yylineno 


DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO})*
CTE         {DIGITO}+
ASIG        "="

%%
{ASIG}          {printf("\tLEX: ASIG: %s \n", yytext);return ASIG;}
{ID}            {printf("\tLEX: ID: %s \n", yytext); yylval.valor_string = strdup(yytext); return ID;}
{CTE}           {printf("\tLEX: CTE: %s \n", yytext);yylval.valor_int = atoi(yytext); return CTE;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%