echo Compilando FLEX y BISON...
@echo off
c:\GnuWin32\bin\flex AsigMult.l
rem pause
c:\GnuWin32\bin\bison -dyv AsigMult.y
rem pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Compilar.exe
rem pause
rem pause
echo OK   Compilado y generado .exe
@echo on
Compilar.exe programa.txt
@echo off
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del Compilar.exe

pause