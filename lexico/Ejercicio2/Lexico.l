%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;
int yylval;

%}
%option noyywrap  
%option yylineno 

DIGITO      [0-9]
LETRA       [a-zA-Z]
DECVAR      "DECVAR"
ENDDEC      "ENDDEC"
CTE_ENT     {DIGITO}+
CTE_REAL    {DIGITO}+"."{DIGITO}+

%%
{CTE_ENT}   {printf("\nConstante: %s\n", yytext); buscar_en_TS(yytext);}
{CTE_ID}   {printf("\nConstante: %s\n", yytext); buscar_en_TS(yytext);}
"\t"
"\n"
.   yyerror();
%%

int main(int argc,char *argv[]) {
    if ((yyin = fopen(argv[1], "rt")) == NULL){
        printf("\nNo se puede abrir el archivo: %s n", argv[1]);
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