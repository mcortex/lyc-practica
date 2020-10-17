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

/*DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO})**/
ID          "id"
FIN         ";"
COMA        ","
ASIG        ":="
EXP         "exp"

%%
{ID}           {printf("\tLEX: ID: %s \n", yytext); yylval.valor_string = strdup(yytext); return ID;}
{FIN}          {printf("\tLEX: fin: %s \n", yytext);return FIN;}
{COMA}         {printf("\tLEX: coma: %s \n", yytext);return COMA;}
{ASIG}         {printf("\tLEX: asignacion: %s \n", yytext);return ASIG;}
{EXP}          {printf("\tLEX: expresion: %s \n", yytext);return EXP;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%