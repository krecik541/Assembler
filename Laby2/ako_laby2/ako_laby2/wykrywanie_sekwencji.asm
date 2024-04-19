.686
.model flat

extern	__read	:	PROC
extern	__write	:	PROC
extern	_ExitProcess@4	:	PROC
extern	_MessageBoxW@16	:	PROC

public _main

.data
tekst		db	'Wczytaj', 10
magazyn		db	80	dup	(?)
liczba_znak	dd	?
sekwencja	db	40	dup (?)
liczba_sekw	dd	?
znal		db	'znaleziono'
koniec		db	?
.code
_main PROC
  
	; wypisywanie zachêty
	push	OFFSET magazyn - OFFSET tekst
	push	OFFSET tekst
	push	1
	call	__write
	add		esp, 12

	; wczytywanie tekstu
	push	80
	push	OFFSET magazyn
	push	0	; klawiatura
	call	__read
	add		esp, 12
	mov		liczba_znak, eax
	
	; wczytywanie szukanej sekwencji
	push	40
	push	OFFSET sekwencja
	push	0	; klawiatura
	call	__read
	add		esp, 12
	mov		liczba_sekw, eax
	dec		liczba_sekw

	; szukanie sekwencji
	mov		ecx, liczba_znak
	sub		ecx, liczba_sekw
	mov		ebx, 0
	dec		liczba_sekw

ptl:	mov		dl, magazyn[ebx]
		mov		esi, 0	; licznik sekwencji

ptl_w:		mov		al, magazyn[ebx + esi]	; przesy³am na al kolejn¹ literê tablicy jeœli poprzednie s¹ zgodne z szukanym s³owem
			cmp		al, sekwencja[esi]	; porównuje kolejne litery
			jne		dalej	
			cmp		esi, liczba_sekw ; czy d³ugoœæ zgodnego fragmentu jest ca³ym szukanym s³owem
			je		znaleziono
			inc		esi
			jmp		ptl_w


dalej:	inc		ebx
		dec		ecx
		jnz		ptl

	push	0
	call	_ExitProcess@4

znaleziono:	push	OFFSET koniec - OFFSET znal
		push	OFFSET znal
		push	1
		call	__write
		add		esp, 12
		push	0
		call	_ExitProcess@4

_main ENDP
END

