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
P_A         "("
P_C         ")"
ASIG        ":="
SUMA        "+"
RESTA       "-"
MULT        "\*"
DIV         "\/"
COMA        ","
MAY         ">"
MEN         "<"
MAY_I       ">="
MEN_I       "<="
CMP_I       "=="
CMP_D       "!="



%%
"if"           {printf("\tLEX: IF: %s \n", yytext);return IF;}
"then"           {printf("\tLEX: THEN: %s \n", yytext);return THEN;}
"else"           {printf("\tLEX: ELSE: %s \n", yytext);return ELSE;}
"endif"           {printf("\tLEX: ENDIF: %s \n", yytext);return ENDIF;}
{ID}            {printf("\tLEX: ID: %s \n", yytext); yylval.valor_string = strdup(yytext); return ID;}
{CTE}     {printf("\tLEX: CTE: %s \n", yytext);yylval.valor_int = atoi(yytext); return CTE;}
{P_A}           {printf("\tLEX: P_A: %s \n", yytext);return P_A;}
{P_C}           {printf("\tLEX: P_C: %s \n", yytext);return P_C;}
{SUMA}          {printf("\tLEX: SUMA: %s \n", yytext);return SUMA;}
{RESTA}         {printf("\tLEX: RESTA: %s \n", yytext);return RESTA;}
{MULT}          {printf("\tLEX: MULT: %s \n", yytext);return MULT;}
{DIV}           {printf("\tLEX: DIV: %s \n", yytext);return DIV;}
{ASIG}          {printf("\tLEX: ASIG: %s \n", yytext);return ASIG;}
{COMA}          {printf("\tLEX: COMA: %s \n", yytext);return COMA;}
{MAY}          {printf("\tLEX: MAY: %s \n", yytext);return MAY;}
{MEN}          {printf("\tLEX: MEN: %s \n", yytext);return MEN;}
{MAY_I}          {printf("\tLEX: MAY_I: %s \n", yytext);return MAY_I;}
{MEN_I}          {printf("\tLEX: MAY: %s \n", yytext);return MEN_I;}
{CMP_I}          {printf("\tLEX: CMP_I: %s \n", yytext);return CMP_I;}
{CMP_D}          {printf("\tLEX: CMP_D: %s \n", yytext);return CMP_D;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%