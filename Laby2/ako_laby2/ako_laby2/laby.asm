.686
.model flat

extern	__read	:	PROC
extern	__write	:	PROC
extern	_ExitProcess@4	:	PROC
extern	_MessageBoxW@16	:	PROC

public _main

.data
tekst		db	'Wczytaj ciag znakow', 10
magazyn		db	80	dup	(0)
liczba_znak	dd	?
magazyn_utf	db	160	dup	(0)
polskie_lat	db	0, 165, 164, 134, 143, 169, 168, 136, 157, 228, 227, 162, 224, 152, 151, 171, 141, 190, 189	; ¹ æ ê ³ ñ ó œ Ÿ ¿
polskie_utf	db	0, 01H, 05H, 01H, 04H, 01H, 07H, 01H, 06H, 01H, 19H, 01H, 18H, 01H, 42H, 01H, 41H, 01H, 44H, 01H, 43H, 00H, 0F3H, 00H, 0D3H, 01H, 5BH, 01H, 5AH, 01H, 7AH, 01H, 79H, 01H, 7CH, 01H, 7BH
magazyn_pom	db	80	dup	(0)
koniec		db	?
.code
_main PROC
  
	; wypisywanie zachêty
	push	OFFSET magazyn - OFFSET tekst
	push	OFFSET tekst
	push	1
	call	__write
	add		esp, 12

	; wczytywanie
	push	80
	push	OFFSET magazyn
	push	0	; klawiatura
	call	__read
	add		esp, 12
	mov		liczba_znak, eax
	sub		liczba_znak, 2


	; pêtla zamieniaj¹ca miejscami wyrazy
	mov		ecx, liczba_znak	; liczba znaków do zamiany
	mov		esi, liczba_znak	; czyszczenie indeksu
	inc		liczba_znak
	mov		edi, 0

ptl1:	mov		dl, magazyn[ecx]
		cmp		dl, ' '
		jne		dalej1
		mov		ebx, ecx
		inc		ebx
ptl_w1:		mov		al, magazyn[ebx]
			mov		magazyn_pom[edi], al
			inc		edi
			inc		ebx
			cmp		ebx, esi
			jbe		ptl_w1
			mov		esi, ecx
dalej1:	dec		ecx
		jnz		ptl1

				mov		ebx, ecx
ostatni:		mov		al, magazyn[ebx]
				mov		magazyn_pom[edi], al
				inc		edi
				inc		ebx
				cmp		ebx, esi
				jbe		ostatni

	push	liczba_znak
	push	OFFSET magazyn_pom
	push	1
	call	__write
	add		esp, 12












	; zamiana z Latin 2 na UTF 16
	mov		ecx, liczba_znak	; liczba znaków do zamiany
	mov		ebx, 0	; czyszczenie indeksu

ptl:	mov		dl, magazyn_pom[ebx]	; przes³anie znaku do dl
		mov		dh, 0				; w dx powinno byæ 00H [dl]
		cmp		dl, 'z'				
		jbe		dalej

		mov		esi, OFFSET polskie_utf - OFFSET polskie_lat	; licznik tablicy
ptl_w:		cmp		dl, polskie_lat[esi]		; porównujê polski znak w latin2 (latin 2) z odpowiednim kodem w tablicy latin2
			jne		dalej_w	
			mov		dl, polskie_utf[esi*2]		; przypisuje m³odszy bajt znaku w utf16
			mov		dh, polskie_utf[esi*2-1]	; przypisuje starszy kod znaku w utf16
			jmp		dalej
dalej_w:	dec		esi		
			jnz		ptl_w

dalej:	mov		magazyn_utf[ebx*2], dl	; przepisuje m³odszy bit do tablicy
		mov		magazyn_utf[ebx*2+1], dh	; przepisuje starszy kod do tablicy
		inc		ebx
		dec		ecx
		jnz		ptl

	mov		eax, liczba_znak
	mov		magazyn_utf[eax*2], 0

	; wypisanie za pomoc¹ MessageBoxW@16
	push	0
	push	OFFSET magazyn_utf
	push	OFFSET magazyn_utf
	push	0
	call	_MessageBoxW@16
	add		esp, 16


	push	0
	call	_ExitProcess@4
_main ENDP
END