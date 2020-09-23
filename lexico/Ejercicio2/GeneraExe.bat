echo Compilando FLEX y BISON...
@echo off
c:\GnuWin32\bin\flex Prueba_Lexico.l
rem pause
c:\GnuWin32\bin\bison -dyv Prueba_Sintactico.y
rem pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o TPFinal.exe
rem pause
rem pause
echo OK   Compilado y generado .exe
@echo on
TPfinal.exe PruebaEjemplo.txt
@echo off
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del TPFinal.exe

pause
