include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.387
.DATA

	MAXTEXTSIZE equ 50
	@_Ingrese_un_valor_pivot_mayor_o_igual_a_1__ 	DB "Ingrese un valor pivot mayor o igual a 1: ",'$',8 dup(?)
	@_pivot 	DD 0
	@_21 	DD 21
	@_1 	DD 1
	@_7 	DD 7
	@_2 	DD 2
	@_33 	DD 33
	@_3 	DD 3
	@_5 	DD 5
	@_4 	DD 4
	@_resul 	DD 0
	@_@suma 	DD 0
	@_@tope 	DD 0
	@_El_resultado_es__ 	DB "El resultado es: ",'$',33 dup(?)
	@_auxR0 	DD 0.0
	@_auxE0 	DD 0
	@_auxR1 	DD 0.0
	@_auxE1 	DD 0
	@_auxR2 	DD 0.0
	@_auxE2 	DD 0
	@_auxR3 	DD 0.0
	@_auxE3 	DD 0

.CODE
.startup
	mov AX,@DATA
	mov DS,AX

	FINIT

	displayString 	@_Ingrese_un_valor_pivot_mayor_o_igual_a_1__
	newLine 1
	GetInteger 	@_pivot
	fild 	@_pivot
	fistp 	@_@tope
	fild 	@_1
	fild 	@_@tope
	fcomp
	fstsw	ax
	fwait
	sahf
	jb		ETIQ17
	fild 	@_21
	fiadd 	@_@suma
	fistp 	@_auxE0
	fild 	@_auxE0
	fistp 	@_@suma
ETIQ17:
	fild 	@_2
	fild 	@_@tope
	fcomp
	fstsw	ax
	fwait
	sahf
	jb		ETIQ28
	fild 	@_7
	fiadd 	@_@suma
	fistp 	@_auxE0
	fild 	@_auxE0
	fistp 	@_@suma
ETIQ28:
	fild 	@_3
	fild 	@_@tope
	fcomp
	fstsw	ax
	fwait
	sahf
	jb		ETIQ39
	fild 	@_33
	fiadd 	@_@suma
	fistp 	@_auxE0
	fild 	@_auxE0
	fistp 	@_@suma
ETIQ39:
	fild 	@_4
	fild 	@_@tope
	fcomp
	fstsw	ax
	fwait
	sahf
	jb		ETIQ50
	fild 	@_5
	fiadd 	@_@suma
	fistp 	@_auxE0
	fild 	@_auxE0
	fistp 	@_@suma
ETIQ50:
	fild 	@_@suma
	fistp 	@_resul
	displayString 	@_El_resultado_es__
	newLine 1
	displayInteger 	@_resul,3
	newLine 1
	mov ah, 4ch
	int 21h


strlen proc
	mov bx, 0
	strl01:
	cmp BYTE PTR [si+bx],'$'
	je strend
	inc bx
	jmp strl01
	strend:
	ret
strlen endp

copiar proc
	call strlen
	cmp bx , MAXTEXTSIZE
	jle copiarSizeOk
	mov bx , MAXTEXTSIZE
	copiarSizeOk:
	mov cx , bx
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
copiar endp

concat proc
	push ds
	push si
	call strlen
	mov dx , bx
	mov si , di
	push es
	pop ds
	call strlen
	add di, bx
	add bx, dx
	cmp bx , MAXTEXTSIZE
	jg concatSizeMal
	concatSizeOk:
	mov cx , dx
	jmp concatSigo
	concatSizeMal:
	sub bx , MAXTEXTSIZE
	sub dx , bx
	mov cx , dx
	concatSigo:
	push ds
	pop es
	pop si
	pop ds
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
concat endp

END