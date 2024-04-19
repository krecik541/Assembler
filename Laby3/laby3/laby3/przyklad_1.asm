.686
.model flat

extern __write	: PROC
extern _ExitProcess@4	:	PROC

public _main

.data
	znaki	db	12	dup (?)
	liczba	dd  4294967295
	tablica	db	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
.code
_main	PROC
	
	mov		eax, liczba

	mov		esi, 10	;	liczba cyfr transformowanej liczby
	mov		ebx, 10	;	podstawa systemu liczbowego na który liczba jest zmieniana

konwersja:	mov		edx, 0	;	zerowanie starszej czêœci dzielnej
			div		ebx		;	dzielenie EDX:EAX przez EBX, iloraz w EAX, reszta w EDX

			;mov		cl, tablica [edx]
			;push	cx
			
			mov		dl, [tablica + edx]	;	tablica[]
			mov		znaki[esi], dl

			dec		esi		;	zmniejszanie indeksu tablicy
			cmp		eax, 0	;	sprawdzenie czy iloraz = 0
			jne		konwersja

	;	
wypeln:		or		esi, esi
			jz		wyswietl
			mov		byte PTR znaki[esi], 20H
			dec		esi
			jmp		wypeln

wyswietl:	
	mov		byte PTR znaki[0], 0AH
	mov		byte PTR znaki[11], 0AH
	

	;	wypisywanie
	push	12
	push	OFFSET znaki
	push	1
	call	__write
	add		esp, 12
	
	
	push	0
	call	_ExitProcess@4
_main	ENDP
END