.686
.model flat

extern	__write	:	PROC
extern	__read	:	PROC
extern	_ExitProcess@4	:	PROC

public	_main

.data
tekst			db	'Podaj tekst i zatwierdz ENTER', 10
magazyn			db	80	dup	(0)
liczba_znakow	dd	?
.code
_main PROC

	; wypisuje proŸbê o wprowadzenie tekstu
	push	OFFSET magazyn - OFFSET tekst
	push	OFFSET tekst
	push	1
	call	__write
	add		esp, 12	; czyszczenie stosu

	; wczytwywanie ci¹gu znaków
	push	80
	push	OFFSET magazyn
	push	0	; 0 = klawiatura
	call	__read	; read(sk¹d pobieramy (tu: 0 = klawiatura), dok¹d, ile znaków)
	add		esp, 12
	
	dec		eax	; ostatni zapisywany znak to 10 chyba
	mov		liczba_znakow, eax	; w eax znajduje siê liczba wczytanych znaków
		
	; odwrócenie tekstu
	mov		ecx, 2
	div		ecx	; dziele eax przez ecx
	mov		ebx, 0	; ustawiam dolny licznik
	mov		ecx, eax	; ustawiam i
	mov		eax, liczba_znakow	; ustawiam gorny licznik
	dec		eax

ptl:	mov		dl, magazyn[ebx]	; przesy³am literê z dolego licznika
		xchg	dl, magazyn[eax]	; wymieniam z liter¹ z górnego licznika
		mov		magazyn[ebx], dl	; wstawiam literê z górnego licznika w miejsce dolnego
		inc		ebx
		dec		eax
		dec		ecx
		jnz		ptl


	

	push	liczba_znakow
	push	OFFSET magazyn
	push	1
	call	__write
	add		esp, 12

	push	0
	call	_ExitProcess@4
_main ENDP
END