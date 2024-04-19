.386
rozkazy SEGMENT use16
		ASSUME	cs:rozkazy

obsluga_klawy PROC
	push	ax
	push	bx
	push	es

	in		al, 60h
	cmp		al, 72
	jne		nie_gorna_strzalka
	mov		cs:kierunek, -320
nie_gorna_strzalka:
	cmp		al, 80
	jne		nie_dolna_strzalka
	mov		cs:kierunek, 320
nie_dolna_strzalka:
	cmp		al, 75
	jne		nie_lewa_strzalka
	mov		cs:kierunek, -1
nie_lewa_strzalka:
	cmp		al, 77
	jne		nie_prawa_strzalka
	mov		cs:kierunek, 1
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


	mov		ax, 0A000H
	mov		es, ax

	mov		bx, cs:adres_piksela ; adres bie¿¹cego piksela 
	mov		al, cs:kolor
	mov		es:[bx], al ; wpisanie kodu koloru do pamiêci ekranu

	; przejœcie do nastêpnego wiersza na ekranie
	add		bx, cs:kierunek

	inc		cs:kolor	; kolejny kod koloru 

	; sprawdzenie czy ca³a linia wykreœlona
	cmp		bx, 320*200
	jb		dalej ; skok gdy linia jeszcze nie wykreœlona



	; zapisanie adresu bie¿¹cego piksela
dalej:
	mov		cs:adres_piksela, bx

	pop		es
	pop		bx
	pop		ax

	jmp		dword ptr cs:wektor8

	;zmienne
	kierunek		dw	? 
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