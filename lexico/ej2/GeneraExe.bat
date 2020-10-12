echo Compilando FLEX...
@echo off
c:\GnuWin32\bin\flex Lexico.l
rem pause
c:\MinGW\bin\gcc.exe lex.yy.c -o Ejercicio2.exe
rem pause
rem pause
echo OK - Compilado y generado .exe
@echo on
Ejercicio2.exe Ejercicio2.txt
@echo off
del lex.yy.c
del Ejercicio2.exe
pause
