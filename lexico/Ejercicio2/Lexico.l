%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
/*#include "y.tab.h"*/
FILE  *yyin;
int yylval;

%}
%option noyywrap  
%option yylineno 

DIGITO      [0-9]
LETRA       [a-zA-Z]

ID          {LETRA}({LETRA}|{DIGITO})*
CTE_ENT     {DIGITO}+
CTE_REAL    {DIGITO}+"."{DIGITO}+
ESPACIO     [ ]
TABULACION  [\t]
CADENA      {COMILLA}({LETRA}|{DIGITO}|{ESPACIO}|{TABULACION}|"!"|":"|">"|"<")*{COMILLA}
PYC         ";"
LL_A        "{"
LL_C        "}"
P_A         "("
P_C         ")"
ASIG        ":"
COMA        ","
COMILLA     ["]
COMP        ("=="|"!="|"<="|">="|"<"|">")
SUMA        "+"
RESTA       "-"
MULT        "\*"
DIV         "\/"
%%
"DECVAR"    {printf("DECVAR: %s\n", yytext);};
"ENDDEC"    {printf("ENDDEC: %s\n", yytext);};
"Integer"   {printf("Integer: %s\n", yytext);};
"write"     {printf("write: %s\n", yytext);};
"if"        {printf("if: %s\n", yytext);};
"else"      {printf("else: %s\n", yytext);};
"while"     {printf("while: %s\n", yytext);};
{ID}        {printf("ID: %s\n", yytext); /*buscar_en_TS(yytext);*/};
{CTE_ENT}   {printf("Constante entera: %s\n", yytext); /*buscar_en_TS(yytext);*/};
{CTE_REAL}  {printf("Constante real: %s\n", yytext); /*buscar_en_TS(yytext);*/};
{CADENA}    {printf("Cadena: %s\n", yytext); /*buscar_en_TS(yytext);*/};
{PYC}       {printf("Punto y coma: %s\n", yytext);};
{LL_A}      {printf("Llave abre: %s\n", yytext);};
{LL_C}      {printf("Llave cierra: %s\n", yytext);};
{P_A}       {printf("Parentesis abre: %s\n", yytext);};
{P_C}       {printf("Parentesis cierra: %s\n", yytext);};
{COMP}      {printf("Operador de comparacion: %s\n", yytext);};
{COMA}      {printf("Coma: %s\n", yytext);};
{COMILLA}   {printf("Comilla: %s\n", yytext);};
{SUMA}      {printf("Suma: %s\n", yytext);};
{RESTA}     {printf("Resta: %s\n", yytext);};
{MULT}      {printf("Multiplicacion: %s\n", yytext);};
{DIV}       {printf("Division: %s\n", yytext);};
{ASIG}      {printf("Asignacion: %s\n", yytext);};
"\t"
"\n"
%%

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