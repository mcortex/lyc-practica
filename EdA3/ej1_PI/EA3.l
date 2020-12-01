%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "funciones.h"
//FILE  *yyin;

%}

%option noyywrap  
%option yylineno 


DIGITO      [0-9]
LETRA       [a-zA-Z]
INICIO_FIN_STR          \"
CADENA      ({LETRA}|{DIGITO}|\.|\:|\;\-|\_|\!|_|" "|\n|\s|\t|\r|\@|\%\!)*
ID          {LETRA}({LETRA}|{DIGITO})*
CTE         {DIGITO}+
CTE_S       {INICIO_FIN_STR}{CADENA}*{INICIO_FIN_STR}
ASIGNA        "="
PARA        "("
PARC        ")"
CA          "["
CC          "]"
COMA        ","
PYC         ";"

%%
"WRITE"         {printf("\tLEX: WRITE: %s \n", yytext);return WRITE;}
"READ"          {printf("\tLEX: READ: %s \n", yytext);return READ;}
"sumaimpar"     {printf("\tLEX: SUMAIMPAR: %s \n", yytext);return SUMAIMPAR;}
{ID}            {printf("\tLEX: ID: %s \n", yytext); 
                if(strlen(yytext) <= 30){
			        yylval.valor_string = strdup(yytext);
			        return ID;
			        }
				mensajeDeError(ErrorLexico,"El nombre de variable excede el limite permitido.",yylineno);
                }
{CTE}           {printf("\tLEX: CTE: %s \n", yytext);
                if(atoll(yytext)>=0 && atoll(yytext)<=32767){
		            yylval.valor_int = atoi(yytext);
		            return CTE;
		            }
				mensajeDeError(ErrorLexico,"El valor de un entero excede el limite permitido.",yylineno);
                }
{CTE_S}	        {printf("\tLEX: CTE_S: %s \n", yytext);
                if(strlen(yytext)<=100){
					yylval.valor_string = strdup(yytext);
					return CTE_S;
					}
				mensajeDeError(ErrorLexico,"El contenido de una cadena excede el limite permitido.",yylineno);
                }
{ASIGNA}        {printf("\tLEX: ASIGNA: %s \n", yytext);return ASIGNA;}
{PARA}          {printf("\tLEX: PARA: %s \n", yytext);return PARA;}
{PARC}          {printf("\tLEX: PARC: %s \n", yytext);return PARC;}
{CA}            {printf("\tLEX: CA: %s \n", yytext);return CA;}
{CC}            {printf("\tLEX: CC: %s \n", yytext);return CC;}
{COMA}          {printf("\tLEX: COMA: %s \n", yytext);return COMA;}
{PYC}           {printf("\tLEX: PYC: %s \n", yytext);return PYC;}
<<EOF>> 		{ yyterminate();}
" "
"\t"
"\n"
. 				{ mensajeDeError(ErrorLexico,"Caracter invalido",yylineno);}
%%