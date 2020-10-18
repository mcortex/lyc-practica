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

P_A         "("
P_C         ")"

%%
{P_A}          {printf("\tLEX: %s \n", yytext);return P_A;}
{P_C}          {printf("\tLEX: %s \n", yytext);return P_C;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%