%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include <conio.h>
#include "y.tab.h"
#include "Pila.c"
#include "funciones.c"


int yystopparser=0;
FILE  *yyin;
int yylex();
int yyerror(char* mensaje);
extern int yylineno;
FILE *fp;

int pos_aux;


// VARIABLES AUXILIARES
char str_aux[100];
char str_auxetiq[100];
int pos_aux=0;
int cant_elem=0;
int cant_impares=0;
int lista_vacia_flag=0;
extern int cursor;

/* Cosas para la declaracion de variables y la tabla de simbolos */
int varADeclarar1 = 0;
int cantVarsADeclarar = 0;
int tipoDatoADeclarar[TAMANIO_TABLA];
int indiceDatoADeclarar = 0;
int indice_tabla = -1;
// int contCuerpo = 0;
int auxOperaciones=0;
int contCond=0;


st *pilaPosicion;


char * msg_error1="No existen suficientes elementos impares para el calculo";
char * msg_error2="La lista tiene menos elementos que el indicado";
char * msg_error3="Le resultado es: ";

%}

%union {
int valor_int;
char *valor_string;
}



%token <valor_string>ID
%token <valor_int>CTE
%token <valor_string>CTE_S
%token WRITE READ SUMAIMPAR
%token PARA PARC
%token CA CC
%token COMA
%token PYC
%token ASIGNA


%%
/*
0. S -> PROG
1. PROG -> SENT
2. PROG -> PROG SENT
3. SENT -> READ | WRITE | ASIG
4. READ -> read id
5. ASIG -> id asigna SUMAIMPAR
6. SUMAIMPAR -> sumaimpar para id pyc ca LISTA cc parc
7. SUMAIMPAR -> sumaimpar para id pyc ca cc parc
8. LISTA -> cte
9. LISTA -> LISTA coma cte
10. WRITE -> write cte_s
11. WRITE -> write id
*/

s:
    {
    printf("**Inicia COMPILADOR**\n");
    pilaPosicion = createEmptyStack();
    } 
    prog {fprintf(fp,"0. S -> PROG \n"); }
    {
    printf("**Fin COMPILADOR ok**\n");
	grabarTabla();
    muestraPolaca();
    grabarPolaca();
    }
    ;

prog:
    sent {fprintf(fp,"1. PROG -> SENT\n");}
    | prog sent {fprintf(fp,"2. PROG -> PROG SENT\n");}
    ;

sent:
    read {fprintf(fp,"3. SENT -> READ\n"); agregarTiposDatosATabla(); indiceDatoADeclarar = 0;}
    | write {fprintf(fp,"3. SENT -> WRITE\n");}
    | asig {fprintf(fp,"3. SENT -> ASIG\n"); agregarTiposDatosATabla(); indiceDatoADeclarar = 0;}
    ;

read:
    READ ID {
            fprintf(fp,"4. READ -> read id(%s) \n", yylval.valor_string);
            
            // VARIABLES A TS
            agregarVarATabla(yylval.valor_string,!ES_CTE_CON_NOMBRE,yylineno);
			varADeclarar1 = indice_tabla; /* Guardo posicion de primer variable de esta lista de declaracion. */
			cantVarsADeclarar++;
            tipoDatoADeclarar[indiceDatoADeclarar++] = Integer;


            insertaEnPolaca($2,Integer); // ID
            insertaEnPolaca("READ",SinTipo); // WRITE
            // ASIGNO EL VALOR LEIDO DE STDIN A PIVOT
            insertaEnPolaca($2,Integer);
            insertaEnPolaca("@pivot",Integer);
            insertaEnPolaca("=",SinTipo);
            }
    
    ;

asig:
    ID ASIGNA sumaimpar {
                        fprintf(fp,"5. ASIG -> id asigna SUMAIMPAR\n");

                        // LA DECLARACION DE VARIABLES (ID) ES IMPLICITA                        
                        agregarVarATabla($1,!ES_CTE_CON_NOMBRE,yylineno);
                        varADeclarar1 = indice_tabla;
                        cantVarsADeclarar++;
                        tipoDatoADeclarar[indiceDatoADeclarar++] = Integer;

                        if(lista_vacia_flag == 1){
                            printf("%s = 0 -  %s\n",$1,msg_error3);

                            insertaEnPolaca(msg_error3,CteString);
                            insertaEnPolaca("WRITE",SinTipo);
                            insertaEnPolaca("0",CteInt);
                            }
                        else {
                            printf("Asigna resultado a id(%s)\n",$1);
                            insertaEnPolaca("@suma",CteInt);
                            }
                        insertaEnPolaca($1,CteInt);
                        insertaEnPolaca("=",SinTipo);
                                                
                        }
    ;

sumaimpar:
            SUMAIMPAR PARA ID PYC CA lista CC PARC {
                                    fprintf(fp,"6. SUMAIMPAR -> sumaimpar para id pyc ca LISTA cc parc\n");
                                    printf("cantidad de componentes: %d\n",cant_elem);
                                    printf("cantidad de impares: %d\n",cant_impares);

                                    // int pos = chequearVarEnTabla(yylval.valor_string,yylineno);
                                    
                                    int pos = chequearVarEnTabla($3,yylineno);

                                    //IF(cant_elem<@pivot)
                                    // sprintf(str_aux, "%d",cant_elem);
                                    // insertaEnPolaca(str_aux,CteInt);
                                    // insertaEnPolaca($3,CteInt);
                                    // insertaEnPolaca("CMP","CMP");
                                    // insertaEnPolaca("BGE","jae");
                                    // sprintf(str_aux, "%d",cursor); // #celda actual; 
                                    // push(pilaPosicion,str_aux); // apilar #celda actual; 
                                    // avanzar(); // avanzar()
                                    // //THEN
                                    // insertaEnPolaca(msg_error2,"cte_string");
                                    // insertaEnPolaca("BI","jmp");
                                    // strcpy(str_aux,pop(pilaPosicion)); // desapilarX (tope_pila) o str_aux=pop(pilaPosicion); // desapilarX (tope_pila)
                                    // pos_aux = atoi(str_aux);
                                    // escribirEnCeldaX(pos_aux); // Escribir en la celda X, el nº de celda actual + 1
                                    // sprintf(str_aux, "%d",cursor); // #celda actual; 
                                    // push(pilaPosicion,str_aux); // apilar #celda actual; 
                                    // avanzar(); // avanzar()
                                    // //ELSE
                                    // //IF(cant_impares>=@pivot)
                                    // sprintf(str_aux, "%d",cant_impares);
                                    // insertaEnPolaca(str_aux,CteInt);
                                    // insertaEnPolaca($3,CteInt);
                                    // insertaEnPolaca("CMP","CMP");
                                    // insertaEnPolaca("BLT","jb");
                                    // sprintf(str_aux, "%d",cursor); // #celda actual; 
                                    // push(pilaPosicion,str_aux); // apilar #celda actual; 
                                    // avanzar(); // avanzar()
                                    // //THEN
                                    // insertaEnPolaca(msg_error1,"cte_string");
                                    // insertaEnPolaca("BI","jmp");
                                    // strcpy(str_aux,pop(pilaPosicion)); // desapilarX (tope_pila) o str_aux=pop(pilaPosicion); // desapilarX (tope_pila)
                                    // pos_aux = atoi(str_aux);
                                    // escribirEnCeldaX(pos_aux); // Escribir en la celda X, el nº de celda actual + 1
                                    // sprintf(str_aux, "%d",cursor); // #celda actual; 
                                    // push(pilaPosicion,str_aux); // apilar #celda actual; 
                                    // avanzar(); // avanzar()
                                    // //ELSE
                                    // insertaEnPolaca($3,CteInt);

                                    }
            | SUMAIMPAR PARA ID PYC CA CC PARC {
                                int pos = chequearVarEnTabla(yylval.valor_string,yylineno);
                                fprintf(fp,"7. SUMAIMPAR -> sumaimpar para id pyc ca cc parc\n");
                                lista_vacia_flag=1;
                                }
            ;

lista:
    CTE {
        fprintf(fp,"8. LISTA -> cte\n");
        
        cant_elem=1;

        if(($1 % 2) != 0){
            printf("cte(%d) es impar -> encolamos\n", yylval.valor_int);

            agregarCteATabla(CteInt); // solo agrego a la TS las ctes con las que voy a operar
            
            cant_impares++;
            sprintf(str_aux, "%d",cant_impares);
            insertaEnPolaca("@pivot",Integer);
            insertaEnPolaca(str_aux,CteInt);
            insertaEnPolaca("CMP",SinTipo); // pivot >= cant_impares? true: suma=suma+CTE, false: siguiente if
            insertaEnPolaca("BLT",SinTipo);
            push(pilaPosicion,cursor);
            //printf("posicion apilada: %d\n",cursor);
            avanzar();
            sprintf(str_aux, "%d",$1);
            insertaEnPolaca("@suma",CteInt);
            insertaEnPolaca(str_aux,CteInt);
            insertaEnPolaca("+",SinTipo);
            insertaEnPolaca("@suma",CteInt);
            insertaEnPolaca("=",SinTipo);
            pos_aux=pop(pilaPosicion); // desapilarX (tope_pila)
            //printf("posicion desapilada: %d\n",pos_aux);
            escribirEnCeldaX(pos_aux); // Escribir en la celda X, el nº de celda actual + 1           

        }
        // else{
        //     printf("cte(%d) es par -> omitimos\n", yylval.valor_int);
        // }
        }
    | lista COMA CTE {
                        fprintf(fp,"9. LISTA -> LISTA coma cte\n");

                        cant_elem++;
                        
                        if(($3 % 2) != 0){
                            printf("cte(%d) es impar -> encolamos\n", yylval.valor_int);
                            
                            agregarCteATabla(CteInt);

                            cant_impares++;
                            sprintf(str_aux, "%d",cant_impares);
                            insertaEnPolaca("@pivot",Integer);
                            insertaEnPolaca(str_aux,CteInt);
                            insertaEnPolaca("CMP",SinTipo); // pivot >= cant_impares? true: suma=suma+CTE, false: siguiente if
                            insertaEnPolaca("BLT",SinTipo);
                            push(pilaPosicion,cursor);
                            //printf("posicion apilada: %d\n",cursor);
                            avanzar();
                            sprintf(str_aux, "%d",$3);
                            insertaEnPolaca("@suma",CteInt);
                            insertaEnPolaca(str_aux,CteInt);
                            insertaEnPolaca("+",SinTipo);
                            insertaEnPolaca("@suma",CteInt);
                            insertaEnPolaca("=",SinTipo);
                            pos_aux=pop(pilaPosicion); // desapilarX (tope_pila)
                            //printf("posicion desapilada: %d\n",pos_aux);
                            escribirEnCeldaX(pos_aux); // Escribir en la celda X, el nº de celda actual + 1
                           
                        }
                        else{
                            printf("cte(%d) es par -> omitimos\n", yylval.valor_int);
                        }
                    }
    ;


write:
    WRITE CTE_S {
        fprintf(fp,"10. WRITE -> write cte_s(%s) \n", yylval.valor_string);

        agregarCteATabla(CteString);

        insertaEnPolaca($2,CteString); // CTE_S
        insertaEnPolaca("WRITE",SinTipo); // WRITE
        }
    | WRITE ID {
                fprintf(fp,"11. WRITE -> write id(%s) \n", yylval.valor_string);
                // EL ID SE DECLARA IMPLICITO POR MEDIO DE ALGUNA ASIGNACION O UN READ
                // CHEQUEAMOS QUE EXISTA EN LA TS:
                int pos = chequearVarEnTabla(yylval.valor_string,yylineno);

                insertaEnPolaca($2,Integer); // ID
                insertaEnPolaca("WRITE",SinTipo); // WRITE
                }
    ;
%%

int main(int argc,char *argv[])
{
    //   pilaExpresion = crearPila();      
    //   pilaBloque = crearPila();
    //   pilaCondicion = crearPila();
    //   pilaEtiq = crearPila();
      fp = fopen("reglas.txt","w"); 
      if (!fp)
            printf("\nNo se puede abrir el archivo reglas.txt \n");
            
      if ((yyin = fopen(argv[1], "rt")) == NULL)
      {
            printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
      }
      else
      {
            yyparse();
            fclose(yyin);
      }
    generarAsm();
    fclose(fp);
    //   vaciarPila(pilaExpresion);      
    //   vaciarPila(pilaBloque);      
    //   vaciarPila(pilaCondicion);
    //   vaciarPila(pilaEtiq);

      return 0;
}



// OPERACIONES QUE HACEN QUE FRENE LA POLACA:
// WRITE, READ: unarios -> apilan un solo operando (n-1) 
// SUMA, ASIGNACION -> apilan dos operandos (n-1)(n-2)
// tipos de datos: cte_int cte_string var_int(id)
//

/* void recorrePolaca(){
    int i;
    printf("|");
    for(i=0;i<cursor;i++) {
        //printf("%s(%s)(pos:%d)|",polaca_inversa[i].celda.dato,polaca_inversa[i].celda.tipo_dato,polaca_inversa[i].celda.posicion);
        printf("%s(%s)|",polaca_inversa[i].celda.dato,polaca_inversa[i].celda.tipo_dato);
    }
    printf("\n");
} */