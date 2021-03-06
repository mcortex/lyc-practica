#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "funciones.h"
#include "PilaAsm.c"

extern int varADeclarar1;
extern int cantVarsADeclarar;
extern int tipoDatoADeclarar[TAMANIO_TABLA];
extern int indiceDatoADeclarar;
extern int indice_tabla;
extern int auxOperaciones;
char msg[100];
char aux_str[100];
m10_stack_t* pilaAsm;
// stASM* pilaAsm;

int cursor=0;
		
void mensajeDeError(enum tipoError error,const char* info, int linea){
  switch(error){ 
        case ErrorLexico: 
            printf("ERROR Lexico en la linea %d. Descripcion: %s\n",linea,info);
            break ;

		case ErrorSintactico: 
            printf("ERROR Sintactico en la linea %d. Descripcion: %s.\n",linea,info);
            break ;
  }

  system ("Pause");
  exit (1);
}


/* Devuleve la posicion en la que se encuentra el elemento buscado, -1 si no encontro el elemento */
int buscarEnTabla(char * nombre){
   int i=0;
   while(i<=indice_tabla){
	   if(strcmp(tabla_simbolo[i].nombre,normalizarId(nombre)) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}

int yyerror(char* mensaje){
	printf("Syntax Error: %s\n", mensaje);
	system ("Pause");
	exit (1);
 }

void agregarVarATabla(char* nombre,int esCteConNombre,int linea){
	 //Si se llena, error
	if(indice_tabla >= TAMANIO_TABLA - 1){
		 printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		 system("Pause");
		 exit(2);
	}
	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		 //Agregar a tabla
		 indice_tabla ++;
		 tabla_simbolo[indice_tabla].esCteConNombre = esCteConNombre; 
		 strcpy(tabla_simbolo[indice_tabla].nombre,normalizarId(nombre));
	}
	else 
	{
	 	sprintf(msg,"'%s' ya se encuentra declarada previamente.", nombre);
	 	mensajeDeError(ErrorSintactico,msg,linea);
	}
}

 /** Agrega los tipos de datos a las variables declaradas. Usa las variables globales varADeclarar1, cantVarsADeclarar y tipoDatoADeclarar */
void agregarTiposDatosATabla(){
	int i;
	for(i = 0; i < cantVarsADeclarar; i++){
		tabla_simbolo[varADeclarar1 + i].tipo_dato = tipoDatoADeclarar[i];
	}
}
/** Guarda la tabla de simbolos en un archivo de texto */
void grabarTabla(){
	if(indice_tabla == -1)
		yyerror("No se encontro la tabla de simbolos");

	FILE* arch = fopen("ts.txt", "w+");
	if(!arch){
		printf("No se pudo crear el archivo ts.txt\n");
		return;
	}
	
	int i;
	char valor[TAM_NOMBRE];
	fprintf(arch, "%-50s|%-50s|%-50s|%-50s|%s\n","NOMBRE","TIPO","VALOR","LONGITUD","ES CTE CON NOMBRE ");
	fprintf(arch, "............................................................................................................................................................................................................................................................................................\n");
	for(i = 0; i <= indice_tabla; i++){
		fprintf(arch, "%-50s", &(tabla_simbolo[i].nombre) );
		// printf("grabamos: %s - tipo_dato: %d - indice: %d\n", &(tabla_simbolo[i].nombre), tabla_simbolo[i].tipo_dato, i );
		switch (tabla_simbolo[i].tipo_dato){
		case Integer:
			if(tabla_simbolo[i].esCteConNombre){
			 	sprintf(valor, "%d", tabla_simbolo[i].valor_i);
			}
			else{
				strcpy(valor,"--");
			}
			fprintf(arch, "|%-50s|%-50s|%-50s|%d","INTEGER",valor,"--",tabla_simbolo[i].esCteConNombre);
			break;
		case CteInt:
			fprintf(arch, "|%-50s|%-50d|%-50s|%s", "CTE_INT",tabla_simbolo[i].valor_i,"--","--");
			break;
		case CteString:
			fprintf(arch, "|%-50s|%-50s|%-50d|%s", "CTE_STRING",&(tabla_simbolo[i].valor_s), tabla_simbolo[i].longitud,"--");
			break;
		}

		fprintf(arch, "\n");
	}
	fclose(arch);
}

 

/** Agrega una constante a la tabla de simbolos */
void agregarCteATabla(int num){
	char nombre[100];

	if(indice_tabla >= TAMANIO_TABLA - 1){
		printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}
	
	switch(num){
		case CteInt:
			sprintf(nombre, "%d", yylval.valor_int);
			//Si no hay otra variable con el mismo nombre...
			if(buscarEnTabla(nombre) == -1){
			//Agregar nombre a tabla
				indice_tabla++;
				strcpy(tabla_simbolo[indice_tabla].nombre,normalizarId(nombre));
			//Agregar tipo de dato
				tabla_simbolo[indice_tabla].tipo_dato = CteInt;
			//Agregar valor a la tabla
				tabla_simbolo[indice_tabla].valor_i = yylval.valor_int;
			}
		break;

		case CteString:
			strcpy(nombre,normalizarNombre(yylval.valor_string));
			// printf("nombre-------------------%s\n",nombre);	
			memmove(&nombre[0], &nombre[1], strlen(nombre));//Remover el primer guion "_"
			if(buscarEnTabla(nombre) == -1){
			//Agregar nombre a tabla
				indice_tabla ++;
				strcpy(tabla_simbolo[indice_tabla].nombre,normalizarNombre(yylval.valor_string));
				// printf("Agregar nombre a tabla: tabla_simbolo[indice_tabla].nombre-------------------%s\n",tabla_simbolo[indice_tabla].nombre);	
				// printf("indice_tabla:  %d\n",indice_tabla);				
				//Agregar tipo de dato
				tabla_simbolo[indice_tabla].tipo_dato = CteString;
				// printf("Agregar tipo de dato: tabla_simbolo[indice_tabla].tipo_dato-------------------%d\n",tabla_simbolo[indice_tabla].tipo_dato);
				// printf("indice_tabla:  %d\n",indice_tabla);

				//Agregar valor a la tabla
				int length = strlen(yylval.valor_string);
				// printf("length-------------------%d\n",length);
				// printf("-------------------%s\n",yylval.valor_string);

				char auxiliar[length];
				strcpy(auxiliar,yylval.valor_string);

				
				auxiliar[strlen(auxiliar)-1] = '\0';
				
				strcpy(tabla_simbolo[indice_tabla].valor_s, auxiliar+1);
				// printf("Agregar valor a la tabla: tabla_simbolo[indice_tabla].valor_s-------------------%s\n",tabla_simbolo[indice_tabla].valor_s);	
				// printf("indice_tabla:  %d\n",indice_tabla);
				
				//Agregar longitud
				tabla_simbolo[indice_tabla].longitud = length -2;
				// printf("Agregar longitud: tabla_simbolo[indice_tabla].longitud-------------------%d\n",tabla_simbolo[indice_tabla].longitud);
				// printf("indice_tabla:  %d\n",indice_tabla);	
				
			}
			
		break;

			case SinTipo:
			if(buscarEnTabla(yylval.valor_string) == -1){
			//Agregar nombre a tabla
				indice_tabla ++;
				strcpy(tabla_simbolo[indice_tabla].nombre,normalizarNombre(yylval.valor_string));			

				//Agregar tipo de dato
				tabla_simbolo[indice_tabla].tipo_dato = SinTipo;
				

				//Agregar valor a la tabla
				int length = strlen(yylval.valor_string);
				char auxiliar[length];
				strcpy(auxiliar,yylval.valor_string);
				auxiliar[strlen(auxiliar)] = '\0';
				strcpy(tabla_simbolo[indice_tabla].valor_s, "--");
				//Agregar longitud
				tabla_simbolo[indice_tabla].longitud = length -2;
	
			}
		break;

	}
}

void insertaMensaje (char * mensaje) {
			char nombre[100];
			strcpy(nombre,normalizarNombre(mensaje));
			// printf("nombre-------------------%s\n",nombre);	
			memmove(&nombre[0], &nombre[1], strlen(nombre));//Remover el primer guion "_"
			if(buscarEnTabla(nombre) == -1){
			//Agregar nombre a tabla
				indice_tabla ++;
				strcpy(tabla_simbolo[indice_tabla].nombre,normalizarNombre(mensaje));
				// printf("Agregar nombre a tabla: tabla_simbolo[indice_tabla].nombre-------------------%s\n",tabla_simbolo[indice_tabla].nombre);	
				// printf("indice_tabla:  %d\n",indice_tabla);
				// printf("tabla_simbolo[indice_tabla].nombre-------------------%s\n",tabla_simbolo[indice_tabla].nombre);				
				//Agregar tipo de dato
				tabla_simbolo[indice_tabla].tipo_dato = CteString;
				// printf("Agregar tipo de dato: tabla_simbolo[indice_tabla].tipo_dato-------------------%d\n",tabla_simbolo[indice_tabla].tipo_dato);
				// printf("indice_tabla:  %d\n",indice_tabla);

				//Agregar valor a la tabla
				int length = strlen(mensaje);
				// printf("length-------------------%d\n",length);
				// printf("-------------------%s\n",mensaje);

				char auxiliar[length];
				strcpy(auxiliar,mensaje);

				
				auxiliar[strlen(auxiliar)-1] = '\0';
				
				strcpy(tabla_simbolo[indice_tabla].valor_s, auxiliar+1);
				// printf("Agregar valor a la tabla: tabla_simbolo[indice_tabla].valor_s-------------------%s\n",tabla_simbolo[indice_tabla].valor_s);	
				// printf("indice_tabla:  %d\n",indice_tabla);
				
				//Agregar longitud
				tabla_simbolo[indice_tabla].longitud = length -2;
				// printf("Agregar longitud: tabla_simbolo[indice_tabla].longitud-------------------%d\n",tabla_simbolo[indice_tabla].longitud);
				// printf("indice_tabla:  %d\n",indice_tabla);	
				
			}
}

void insertarEntero(int numero) {
			char nombre[100];
			sprintf(nombre, "%d", numero);
			//Si no hay otra variable con el mismo nombre...
			if(buscarEnTabla(nombre) == -1){
			//Agregar nombre a tabla
				indice_tabla++;
				strcpy(tabla_simbolo[indice_tabla].nombre,normalizarId(nombre));
			//Agregar tipo de dato
				tabla_simbolo[indice_tabla].tipo_dato = CteInt;
			//Agregar valor a la tabla
				tabla_simbolo[indice_tabla].valor_i = numero;
			}	
}


char* normalizarNombre(const char* nombre){
    char *aux = (char *) malloc( sizeof(char) * (strlen(nombre)) + 2);
	char *retor = (char *) malloc( sizeof(char) * (strlen(nombre)) + 2);

	strcpy(retor,nombre);
	int len = strlen(nombre);
	retor[len-1] = '\0';
		
	strcpy(aux,"_");
	strcat(aux,++retor);

	return reemplazarCaracter(aux);
}

char* normalizarId(const char* cadena){
	char *aux = (char *) malloc( sizeof(char) * (strlen(cadena)) + 2);
	strcpy(aux,"_");
	strcat(aux,cadena);
	reemplazarCaracter(aux);
	return aux;
}

char * reemplazarCaracter(char * aux){
	int i=0;
	for(i = 0; i <= strlen(aux); i++)
  	{
  		if(aux[i] == '\t' || aux[i] == '\r' || aux[i] == ' ' || aux[i] == ':')  
		{
  			aux[i] = '_';
 		}

		if(aux[i] == '.')  
		{
  			aux[i] = 'p';
 		}
	}
	return aux;
}

/** Se fija si ya existe una entrada con ese nombre en la tabla de simbolos. Si no existe, muestra un error de variable sin declarar y aborta la compilacion. */
int chequearVarEnTabla(char* nombre,int linea){
	int pos=0;
	pos=buscarEnTabla(nombre);
	//Si no existe en la tabla, error
	if( pos == -1){
		sprintf(msg,"La variable '%s' esta declarada de forma incorrecta.", nombre);
		mensajeDeError(ErrorSintactico,msg,linea);
	}
	//Si existe en la tabla, dejo que la compilacion siga
	return pos;
}

void validarCteEnTabla(char* nombre,int linea){
	int pos = buscarEnTabla(nombre); 
	if(tabla_simbolo[pos].esCteConNombre){
		mensajeDeError(ErrorSintactico,"No se puede asignar valor a la cte",linea);
	}
}

void agregarValorACte(int tipo){
	switch (tipo){
		case CteInt:{
			tabla_simbolo[indice_tabla].valor_i = tabla_simbolo[indice_tabla - 1].valor_i;
			break;
		}
		case CteString:{
			strcpy(tabla_simbolo[indice_tabla].valor_s, tabla_simbolo[indice_tabla -1].valor_s);
		break;	
		}
	}
}



void insertaEnPolaca(char * dato, int tipo_dato) {

    strcpy(polaca_inversa[cursor].celda.dato,dato);
	polaca_inversa[cursor].celda.tipo_dato = tipo_dato;
    // strcpy(polaca_inversa[cursor].celda.tipo_dato,tipo_dato);
    polaca_inversa[cursor].celda.posicion=cursor;
    cursor++;
}

void muestraPolaca(){
	printf("---------------MOSTRAR POLACA INVERSA---------------\n");
    int i;
    printf("|");
    for(i=0;i<cursor;i++) {
        printf("%s(%d)(pos:%d)|",polaca_inversa[i].celda.dato,polaca_inversa[i].celda.tipo_dato,polaca_inversa[i].celda.posicion);
        //printf("%s(%s)|",polaca_inversa[i].celda.dato,polaca_inversa[i].celda.tipo_dato);
    }
    printf("\n");
}

void avanzar(){
    insertaEnPolaca("NULL",SinTipo);
}

void escribirEnCeldaX(int posicion) {
	char * str_aux;
	int cursor_tmp;
	cursor_tmp = cursor;
	// printf("posicion a escribir: %d", posicion);
	// printf("cursor a escribir: %d", cursor_tmp);

    sprintf(str_aux, "#ETIQ%d",cursor_tmp);
	// printf("str_aux: %s", str_aux);
    strcpy(polaca_inversa[posicion].celda.dato,str_aux);
    // strcpy(polaca_inversa[posicion].celda.tipo_dato,"ETIQ");
	polaca_inversa[posicion].celda.tipo_dato=7;
}

void escribirEnCeldaXMasUno(int posicion) {
	char * str_aux;
	int cursor_tmp;
	cursor_tmp = cursor+1;
	// printf("posicion a escribir: %d", posicion);
	// printf("cursor a escribir: %d", cursor_tmp);

    sprintf(str_aux, "#ETIQ%d",cursor_tmp);
	// printf("str_aux: %s", str_aux);
    strcpy(polaca_inversa[posicion].celda.dato,str_aux);
    // strcpy(polaca_inversa[posicion].celda.tipo_dato,"ETIQ");
	polaca_inversa[posicion].celda.tipo_dato=7;
}

void grabarPolaca(){
	printf("---------------GENERAMOS POLACA INVERSA---------------\n");
	int i;
	FILE *polaca;
	
	polaca = fopen("intermedia.txt","w"); 
	if (!polaca)
    	printf("\nNo se puede abrir el archivo intermedia.txt \n");
    
	
    fprintf(polaca,"| ");
    for(i=0;i<cursor;i++) {
        //fprintf(polaca,"%s (%s) | ",polaca_inversa[i].celda.dato,polaca_inversa[i].celda.tipo_dato);
		fprintf(polaca,"%s | ",polaca_inversa[i].celda.dato);
    }
    fprintf(polaca,"\n");
}



// GENERACION DE CODIGO ASSEMBLER:


void generarAsm(){     
    printf("---------------GENERAMOS ASM---------------\n");
	pilaAsm = crearPila();   

	int i;//Contador for
	FILE *pf = fopen("Final.asm", "w+");

	

	if (!pf){
		printf("Error al guardar el archivo assembler.\n");
		exit(1);
	}
	//includes asm
	fprintf(pf, "include macros2.asm\n");
	fprintf(pf, "include number.asm\n\n");
	fprintf(pf,".MODEL LARGE\n.STACK 200h\n.386\n.387\n.DATA\n\n\tMAXTEXTSIZE equ 50\n");
	
	//Data
	for (i = 0; i <= indice_tabla; i++){
		switch (tabla_simbolo[i].tipo_dato){
			case Integer:
				if(tabla_simbolo[i].esCteConNombre){
					fprintf(pf, "\t@%s \tDW %d\n",tabla_simbolo[i].nombre,tabla_simbolo[i].valor_i);
				}
				else{
					// fprintf(pf, "\t@%s \tDW 0\n",tabla_simbolo[i].nombre);
					fprintf(pf, "\t@%s \tDD 0\n",tabla_simbolo[i].nombre);
				}
				break;
			case CteInt:
				// fprintf(pf,"\t@%s \tDW %d\n",tabla_simbolo[i].nombre,tabla_simbolo[i].valor_i);
				fprintf(pf,"\t@%s \tDD %d\n",tabla_simbolo[i].nombre,tabla_simbolo[i].valor_i);
				break;
			case CteString:
				fprintf(pf,"\t@%s \tDB \"%s\",'$',%d dup(?)\n",tabla_simbolo[i].nombre,tabla_simbolo[i].valor_s,50-tabla_simbolo[i].longitud);
				break;
			default:
				break;
			}
	}
	
	//Auxiliares
	for(i=0;i<auxOperaciones;i++){
		// fprintf(pf,"\t@_auxR%d \tDD 0.0\n",i);
		fprintf(pf,"\t@_auxE%d \tDD 0\n",i);
	}

	fprintf(pf,"\n.CODE\n.startup\n\tmov AX,@DATA\n\tmov DS,AX\n\n\tFINIT\n\n");

	// recorrerArbol(auxArbol,pf);

	recorrerPolaca(pf);

	fprintf(pf,"\tmov ah, 4ch\n\tint 21h\n\n");

	//FUNCIONES PARA MANEJO DE ENTRADA/SALIDA Y CADENAS
	fprintf(pf,"\nstrlen proc\n\tmov bx, 0\n\tstrl01:\n\tcmp BYTE PTR [si+bx],'$'\n\tje strend\n\tinc bx\n\tjmp strl01\n\tstrend:\n\tret\nstrlen endp\n");
	fprintf(pf,"\ncopiar proc\n\tcall strlen\n\tcmp bx , MAXTEXTSIZE\n\tjle copiarSizeOk\n\tmov bx , MAXTEXTSIZE\n\tcopiarSizeOk:\n\tmov cx , bx\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\ncopiar endp\n");
	fprintf(pf,"\nconcat proc\n\tpush ds\n\tpush si\n\tcall strlen\n\tmov dx , bx\n\tmov si , di\n\tpush es\n\tpop ds\n\tcall strlen\n\tadd di, bx\n\tadd bx, dx\n\tcmp bx , MAXTEXTSIZE\n\tjg concatSizeMal\n\tconcatSizeOk:\n\tmov cx , dx\n\tjmp concatSigo\n\tconcatSizeMal:\n\tsub bx , MAXTEXTSIZE\n\tsub dx , bx\n\tmov cx , dx\n\tconcatSigo:\n\tpush ds\n\tpop es\n\tpop si\n\tpop ds\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\nconcat endp\n");

	//Fin archivo
	fprintf(pf, "\nEND");
	fclose(pf);
	vaciarPila(pilaAsm);
}

void recorrerPolaca(FILE * pf){
	int i;
	tInfo *cell;
	
    for(i=0;i<cursor;i++) {
		cell = &(polaca_inversa[i].celda);
		// printf("tratamos la celda: %s\n", cell->dato);
		tratarCelda(cell, pf);
    }
}

void tratarCelda(tInfo *cel,FILE *pf){
	//Escribimos en el .asm 
	int pos;
	int i;
	int nroAuxEntero=0;
	// int nroAuxReal=0;
	char aux1[50]="aux\0";
	char aux2[10];
	
	//Variables y Constantes
	sprintf(aux_str,"%s",cel->dato);

	// printf("string aux: %s tipo dato: %d\n",aux_str,cel->tipo_dato);

	switch(cel->tipo_dato){

		case CteInt:
			sprintf(aux_str, "%s",cel->dato);
			pos=buscarEnTabla(aux_str);
			break;
		case CteString:
			strcpy(aux_str,normalizarNombre(aux_str));
			memmove(&aux_str[0], &aux_str[1], strlen(aux_str));//Remover el primer guion "_"
			pos=buscarEnTabla(aux_str);
		break;
		default:
			pos=buscarEnTabla(aux_str);
		break;
	}
	// Si esta en la tabla de simbolos apilo operando
	if(pos!=-1){
		strcpy(cel->dato,normalizarId(aux_str));
		// printf("encolamos operando: %s\n", cel->dato);
		ponerenPila(pilaAsm,cel);
	}	
	
	//WRITE
	if(strcmp(aux_str,"WRITE")==0){
		auxPtr = topedePila(pilaAsm);
		// printf("WRITE string aux: %s tipo dato: %d\n",auxPtr->dato,cel->tipo_dato);
		switch(auxPtr->tipo_dato){
			case Integer:
			case CteInt:
				// printf("WRITE cteint: %s\n",auxPtr->dato);
				fprintf(pf,"\tdisplayInteger \t@%s,3\n\tnewLine 1\n",auxPtr->dato);
			break;
			case String:
			case CteString:
				fprintf(pf,"\tdisplayString \t@%s\n\tnewLine 1\n",auxPtr->dato);
			break;
		}
		sacardePila(pilaAsm);

	}

	if(strcmp(aux_str,"READ")==0){
		auxPtr = topedePila(pilaAsm);
		// printf("READ string aux: %s tipo dato: %d\n",auxPtr->dato,cel->tipo_dato);
		switch(auxPtr->tipo_dato){
			case Integer:
				fprintf(pf,"\tGetInteger \t@%s\n",auxPtr->dato);
			break;
			case String:
				fprintf(pf,"\tgetString \t@%s\n",auxPtr->dato);
				break;	
		}
		sacardePila(pilaAsm);
	}

	// Asignacion 
	if(strcmp(aux_str,"=")==0 ){
		auxPtr = topedePila(pilaAsm);
		switch(auxPtr->tipo_dato){
			case Integer:
			case CteInt:
				sacardePila(pilaAsm);
				auxPtr2 = topedePila(pilaAsm);
				fprintf(pf,"\tfild \t@%s\n",auxPtr2->dato);
				fprintf(pf,"\tfistp \t@%s\n",auxPtr->dato);
			break;
		}
		sacardePila(pilaAsm);
	}

	//Operaciones aritmeticas

	if(strcmp(aux_str,"+")==0){
		auxPtr = topedePila(pilaAsm);
		switch(auxPtr->tipo_dato){
			case Integer:
			case CteInt:	
				fprintf(pf,"\tfild \t@%s\n", auxPtr->dato);
				sacardePila(pilaAsm);
				auxPtr = topedePila(pilaAsm);
				fprintf(pf,"\tfiadd \t@%s\n",auxPtr->dato);
				strcpy(aux1,"_auxE");
				itoa(nroAuxEntero,aux2,10);
				strcat(aux1,aux2);
				fprintf(pf,"\tfistp \t@%s\n", aux1);
				sacardePila(pilaAsm);			
				strcpy(auxPtr->dato,aux1);
				auxPtr->tipo_dato=Integer;
				ponerenPila(pilaAsm,auxPtr);
				nroAuxEntero++;
		break;			
		}
	}


	if(strcmp(aux_str,"CMP")==0){
		auxPtr = topedePila(pilaAsm);
		switch(auxPtr->tipo_dato){
			case Integer:
			case CteInt:
				fprintf(pf,"\tfild \t@%s\n", auxPtr->dato);
				sacardePila(pilaAsm);
				auxPtr = topedePila(pilaAsm);
				fprintf(pf,"\tfild \t@%s\n", auxPtr->dato);
			break;
		}
		sacardePila(pilaAsm);
	}

	// >
	if(strcmp(aux_str,"BLE")==0){
		fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjbe\t\t");
	}

	//<
	if(strcmp(aux_str,"BGE")==0){
		fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjae\t\t");
	}

	//!=
	if(strcmp(aux_str,"BEQ")==0){
		fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tje\t\t");
	}

	//==
	if(strcmp(aux_str,"BNE")==0){
		fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjne\t\t");
	}

	//>=
	if(strcmp(aux_str,"BLT")==0){
		fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjb\t\t");
	}

	//<=
	if(strcmp(aux_str,"BGT")==0){
		fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tja\t\t");
	}

	if(strcmp(aux_str,"BI")==0){
		fprintf(pf,"\tjmp\t\t");
	}

	//ETIQUETAS
	if(strchr(aux_str, '#')!=NULL){
		memmove(&aux_str[0], &aux_str[1], strlen(aux_str));//Remover el primer caracter "#"
		fprintf(pf,"%s\n",aux_str);
	}
}

