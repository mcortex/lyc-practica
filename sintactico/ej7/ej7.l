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

INICIO      "INICIO"
FIN         "FIN"
DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO})*
CONST_INT     {DIGITO}+
PYC         ";"
P_A         "("
P_C         ")"
ASIG        ":="
SUMA        "+"
RESTA       "-"
MULT        "\*"
DIV         "\/"

%%
{INICIO}        {printf("\tLEX: LEO INICIO: %s \n", yytext);return INICIO;}
{FIN}           {printf("\tLEX: LEO FIN: %s \n", yytext);return FIN;}
{ID}            {printf("\tLEX: ID: %s \n", yytext); yylval.valor_string = strdup(yytext); return ID;}
{CONST_INT}     {printf("\tLEX: CONST_INT: %s \n", yytext);yylval.valor_int = atoi(yytext); return CONST_INT;}
{PYC}           {printf("\tLEX: LEO FIN DE LINEA: %s \n", yytext);return PYC;}
{P_A}           {printf("\tLEX: (: %s \n", yytext);return P_A;}
{P_C}           {printf("\tLEX: ): %s \n", yytext);return P_C;}
{SUMA}          {printf("\tLEX: +: %s \n", yytext);return SUMA;}
{RESTA}         {printf("\tLEX: -: %s \n", yytext);return RESTA;}
{MULT}          {printf("\tLEX: *: %s \n", yytext);return MULT;}
{DIV}           {printf("\tLEX: /: %s \n", yytext);return DIV;}
{ASIG}          {printf("\tLEX: Asignacion: %s \n", yytext);return ASIG;}
" "
"\t"
"\n"            { printf( "\tLEX: NUEVA LINEA \n");}
.               yyerror("invalid character");
%%
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