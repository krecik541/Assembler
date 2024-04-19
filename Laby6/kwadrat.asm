.386
rozkazy SEGMENT use16
		ASSUME	cs:rozkazy


rysuj_kwadrat PROC
	push	ax
	push	bx
	push	es
	push	cx
	push	dx
	push	cs:krawedz

	mov		ax, 0A000H
	mov		es, ax

	mov		al, cs:kolor
	mov		cx, cs:krawedz
	mov		dx, cs:krawedz

	mov		bx, 0
kw:	
	mov		es:[bx], al ; wpisanie kodu koloru do pamiêci ekranu
	inc		bx
	cmp		bx, cs:krawedz
	jne		kw
	
	add		bx, 320
	sub		bx, dx
	add		cs:krawedz, 320
	
	dec		cx
	cmp		cx, 0
	ja		kw


	pop		cs:krawedz
	pop		dx
	pop		cx
	pop		es
	pop		bx
	pop		ax
	ret
rysuj_kwadrat ENDP

obsluga_klawy PROC
	push	ax
	push	bx
	push	es

	in		al, 60h
	cmp		al, 19
	jne		nie_rowne
	inc		cs:licznik
nie_rowne:
	pop		es
	pop		bx
	pop		ax

	jmp		dword ptr cs:wektor9
obsluga_klawy ENDP

linia PROC
	push	ax
	push	bx
	push	es

	
	dec dword ptr cs:czas_oczekiwania 
	jnz skip
	mov	dword ptr cs:czas_oczekiwania, 5

	mov		al, cs:kolor_czarny
	cmp		cs:kolor, al
	jne		na_czarny
	cmp		cs:licznik, 36
	jbe		zolty

	mov		al, cs:kolor_czerwony
	mov		cs:kolor, al
	jmp		rysuj
zolty:
	mov		al, cs:kolor_zolty
	mov		cs:kolor, al
	jmp		rysuj
na_czarny:
	mov		al, cs:kolor_czarny
	mov		cs:kolor, al

rysuj:

	call	rysuj_kwadrat


	; zapisanie adresu bie¿¹cego piksela
dalej:
	mov		cs:adres_piksela, bx
skip:
	pop		es
	pop		bx
	pop		ax

	jmp		dword ptr cs:wektor8

	;zmienne
	kolor			db	1
	licznik			dw	0
	adres_piksela	dw	10
	przyrost		dw	0
	wektor8			dd	?
	wektor9			dd	?
	czas_oczekiwania dd 5
	kolor_czarny	db	0
	kolor_zolty		db	14
	kolor_czerwony	db	12
	krawedz			dw	50
linia ENDP

zacznij:
	mov ah, 0
	mov al, 13H						; nr trybu
	int 10H
	mov bx, 0
	mov es, bx						; zerowanie rejestru ES
	mov eax, es:[32]				; odczytanie wektora nr 8
	mov cs:wektor8, eax				; zapamiêtanie wektora nr 8

	mov eax, es:[36]				; odczytanie wektora nr 9
	mov cs:wektor9, eax				; zapamiêtanie wektora nr 9

	; adres procedury 'kwadrat' w postaci segment:offset
	mov ax, SEG linia
	mov bx, OFFSET linia

	cli								
	mov es:[32], bx
	mov es:[32+2], ax
	sti								

	mov ax, SEG obsluga_klawy
	mov bx, OFFSET obsluga_klawy

	cli
	mov es:[36], bx
	mov es:[36+2], ax
	sti


aktywne_oczekiwanie:
	mov		ah, 1
	int		16H
	jz		aktywne_oczekiwanie

	mov		ah, 0
	int		16H
	cmp		al, 'x'							
	jne aktywne_oczekiwanie	

	mov ah, 0						; funkcja nr 0 ustawia tryb sterownika
	mov al, 3H						; nr trybu
	int 10H

	; odtworzenie oryginalnej zawartoœci wektora nr 8
	mov eax, cs:wektor8
	mov es:[32], eax

	; odtworzenie oryginalnej zawartoœci wektora nr 9
	mov eax, cs:wektor9
	mov es:[36], eax

	; zakoñczenie wykonywania programu
	mov ax, 4C00H
	int 21H
rozkazy ENDS

stosik	SEGMENT stack
	db	256	dup	(?)
stosik	ENDS

END zacznij