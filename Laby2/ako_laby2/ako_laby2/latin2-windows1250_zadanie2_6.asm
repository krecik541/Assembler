.686
.model flat

extern	__write	:	PROC
extern	__read	:	PROC
extern	_ExitProcess@4	:	PROC
extern	_MessageBoxA@16	:	PROC

public _main

.data
tekst	db	'Podaj tekst', 10
magazyn	db	80	dup	(32)
l_znak	dd	?
znak_m	db	0, 0A5H, 86H, 0A9H, 88H, 0E4H, 0A2H, 98H, 0ABH, 0BEH, 164, 143, 168, 157, 227, 224, 151, 141, 189	; kody ma³ych polskich liter w Latin 2
znak_d	db	0, 185, 230, 234, 179, 241, 243, 156, 159, 191, 165, 198, 202, 163, 209, 211, 140, 143, 175	; kody du¿ych polskich liter w Windows-1250

.code
_main	PROC

	; wypisanie zachêty
	push	OFFSET magazyn - OFFSET tekst
	push	OFFSET tekst
	push	1
	call	__write
	add		esp, 12

	; pobranie tekstu
	push	80
	push	OFFSET magazyn
	push	0 ; klawiatura
	call	__read
	add		esp, 12

	; zapisanie liczby wczytanych liter w zmiennej
	mov		l_znak, eax

	; zamiana polskich liter
	mov		ecx, eax	; licznik
	mov		ebx, 0	; indeks tablicy

ptl:	mov		dl, magazyn[ebx]	; pobieram kolejn¹ literê z tablicy
		cmp		dl, 'z'
		jb		dalej		; jeœli litera jest poni¿ej 'z' to nie mo¿e byc ona polsk¹ liter¹
		mov		esi, OFFSET znak_d - znak_m		; ustawia licznik wewnêtrznej pêtli, która przejdzie po tablicy polskich znaków

ptl_w:		cmp		dl, znak_m[esi]
			jne		dalej_w			; jeœli kod ascii w dl jest ró¿ny od litery zawartej w znak_m[j]
			mov		dl, znak_d[esi]		; przypisuje kodowi polskiej litery w Latin 2 kod tej samej litery w Windows 1250
			mov		magazyn[ebx], dl	; zapisuje kod nowej litery w magazyn[i] 
			jmp		dalej	; break
dalej_w:	dec		esi		; j--
			jnz		ptl_w	; while(j > 0)


dalej:	inc		ebx	; licz++
		dec		ecx	; i--
		jnz		ptl	; while(i>0)

	; ci¹g znaków musi siê koñczyæ '0'
	mov		eax, l_znak
	mov		magazyn[eax], 0


	; wypisanie tekstu w messagebox
	push	0
	push	OFFSET	magazyn
	push	OFFSET	magazyn
	push	0
	call	_MessageBoxA@16
	add		esp, 16


	push	0
	call	_ExitProcess@4
_main ENDP
END