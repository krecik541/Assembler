.386
rozkazy SEGMENT use16
		ASSUME	cs:rozkazy

clear PROC
	push	ax
	push	bx
	push	es

	mov		ax, 0A000H
	mov		es, ax

	mov		al, 0
	mov		bx, 0
ptl:
	mov		es:[bx], al ; wpisanie kodu koloru do pamiêci ekranu
	add		bx, 1
	cmp		bx, 320*200
	jb		ptl

	pop		es
	pop		bx
	pop		ax
	ret
clear ENDP

rysuj_kwadrat PROC
	push	ax
	push	bx
	push	es
	push	cx
	push	dx
	push	cs:krawedz
	
	call	clear
	
	mov		ax, 0A000H
	mov		es, ax


	mov		bx, cs:start_x
	add		bx, cs:start_y
	add		cs:krawedz, bx
	
	mov		cx, 100
	mov		al, cs:kolor
	mov		dx, cs:krawedz
	
kw:	
	mov		es:[bx], al ; wpisanie kodu koloru do pamiêci ekranu
	inc		bx
	cmp		bx, cs:krawedz
	jb		kw
	
	add		bx, 160
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
	cmp		al, 72
	jne		nie_gorna_strzalka
	cmp		cs:start_y, 0
	je		nie_prawa_strzalka
	sub		cs:start_y, 32000
nie_gorna_strzalka:
	cmp		al, 80
	jne		nie_dolna_strzalka
	cmp		cs:start_y, 32000
	je		nie_prawa_strzalka
	add		cs:start_y, 32000
nie_dolna_strzalka:
	cmp		al, 75
	jne		nie_lewa_strzalka
	cmp		cs:start_x, 0
	je		nie_prawa_strzalka
	sub		cs:start_x, 160
nie_lewa_strzalka:
	cmp		al, 77
	jne		nie_prawa_strzalka
	cmp		cs:start_x, 160
	je		nie_prawa_strzalka
	add		cs:start_x, 160
nie_prawa_strzalka:

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
	mov	dword ptr cs:czas_oczekiwania, 18

	mov	al, cs:kolor_czer
	cmp	cs:kolor, al
	jne	nie_czerw
	mov	al, cs:kolor_ziel
	mov cs:kolor, al
	jmp	dal
nie_czerw:
	mov	al, cs:kolor_ziel
	cmp	cs:kolor, al
	jne	nie_ziel
	mov	al, cs:kolor_nieb
	mov cs:kolor, al
	jmp	dal
nie_ziel:
	mov	al, cs:kolor_czer
	mov cs:kolor, al
dal:

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
	licznik			dw	0
	adres_piksela	dw	10
	przyrost		dw	0
	wektor8			dd	?
	wektor9			dd	?
	czas_oczekiwania dd 5
	kolor		db ?
	kolor_czer	db 4
	kolor_ziel	db 2
	kolor_nieb	db 1
	krawedz		dw	160
	start_x		dw	0
	start_y		dw	0
	kierunek	dw	0

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