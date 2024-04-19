.686
.model flat

extern	__write	: PROC
extern	_ExitProcess@4	: PROC

public	_main

.data
znaki	db	12	dup	(?)
liczba	dd	4294967295

.code
wyswietl_EAX PROC
	pusha
	mov		esi, 10	; liczba cyfr
	mov		ebx, 10	; dzielnik

konwersja:	mov		edx, 0	; starsze bity dzielnej
			div		ebx		; dziele EDX:EAX przez EBX
			add		edx, 30H ; w EDX znajduje siê reszta z dzielenia, tworzê z tej reszty ten sam znak w ASCII
			mov		znaki[esi], dl ; przesylam znak do tablicy
			dec		esi	
			cmp		eax, 0
			jne		konwersja

wypelnij:	cmp		esi, 0
			je		wyswietl
			mov		byte PTR znaki[esi], 0H ; zamiast 0 bêd¹ spacje
			dec		esi
			jmp		wypelnij

wyswietl:

	mov		znaki[0], 20H
	mov		znaki[11], ','


	; wyœwietlanie
	push	12
	push	OFFSET znaki
	push	1
	call	__write
	add		esp, 12


	popa
	ret
wyswietl_EAX ENDP

_main	PROC
	
	; mov		eax, liczba
	mov		eax, 1
	call	wyswietl_EAX
	mov		ebx, 1
	mov		eax, 2
	call	wyswietl_EAX
	mov		esi, 48

ptl:	mov		ecx, eax
		add		eax, ebx
		mov		ebx, ecx
		call	wyswietl_EAX
		dec		esi
		jnz		ptl

	push	0
	call	_ExitProcess@4
_main ENDP
END