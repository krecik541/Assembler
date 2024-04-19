.686
.model flat

extern	__write	:	PROC
extern	__read	:	PROC
extern	_ExitProcess@4	:	PROC

public	_main

.data
tekst			db	'Podaj tekst i zatwierdz ENTER', 10
magazyn		db	80	dup	(0)
liczba_znakow	dd	?
; ¹ 0A5H 0A4H, æ 86H 8FH, ê 0A9H 0A8H, ³ 88H 9DH, ñ 0E4H 0E3H, ó 0A2H 0E0H, œ 98H 97H, Ÿ 0ABH 8DH, ¿ 0DEH 0BDH
polskie_znaki_m	db	0, 0A5H, 86H, 0A9H, 88H, 0E4H, 0A2H, 98H, 0ABH, 0BEH
polskie_znaki_d db	0, 0A4H, 8FH, 0A8H, 9DH, 0E3H, 0E0H, 97H, 8DH, 0BDH
koniec			db	?
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

		mov		liczba_znakow, eax	; w eax znajduje siê liczba wczytanych znaków


		; sprawdzam co zosta³o wczytane
			; push	liczba_znakow
			; push	OFFSET wczytany
			; push	1
			; call	__write
			; add		esp, 12

		; zamian polskich liter na wielkie
		mov		ecx, eax	; liczba wczytanych znaków jest ograniczeniem	->   for(int i = wczytane znaki; i != 0; i--)     i = ecx = eax
		mov		ebx, 0	; zeruje licznik 
ptl:	mov		dl, magazyn[ebx]	; przesy³a litere z kolejn¹ literê z tablicy
		cmp		dl, 'z'
		jb		dalej	; jeœli (dl	< (int)'a'); kod ascii w dl jest mniejszy od a
		
		; porównanie liter
		mov		esi, OFFSET polskie_znaki_d - OFFSET polskie_znaki_m	; licznik wewnêtrznej pêtli
w_ptl:	cmp		dl, polskie_znaki_m[esi]
		jne		rozne	; jeœli s¹ ró¿ne, nale¿y skoczyæ
		mov		dl, polskie_znaki_d[esi] ; zamiana ma³ej litery na du¿¹
		mov		magazyn[ebx], dl ; przes³anie du¿ej litery do tablicy
		jmp		exit
rozne:	dec		esi	; i--
		jnz		w_ptl


dalej:	sub		dl, 20H										; zamiana na wielkie litery
		mov		magazyn[ebx], dl
exit:	inc		ebx	
		dec		ecx	; i--
		jnz		ptl

	dec		liczba_znakow	; ostatni zapisywany znak to 10 chyba

	push	liczba_znakow
	push	OFFSET magazyn
	push	1
	call	__write
	add		esp, 12

	push	0
	call	_ExitProcess@4
_main ENDP
END