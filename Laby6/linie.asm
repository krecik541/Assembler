.386
rozkazy SEGMENT use16
		ASSUME	cs:rozkazy

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
	add		bx, 320+1

	; sprawdzenie czy ca³a linia wykreœlona
	cmp		bx, 320*200
	jb		dalej ; skok gdy linia jeszcze nie wykreœlona

	; kreœlenie linii zosta³o zakoñczone - nastêpna linia bêdzie
	; kreœlona w innym kolorze o 10 pikseli dalej
	add		word ptr cs:przyrost, 10
	mov		bx, 10
	add		bx, cs:przyrost
	inc		cs:kolor	; kolejny kod koloru

	; zapisanie adresu bie¿¹cego piksela
dalej:
	mov		cs:adres_piksela, bx

	pop		es
	pop		bx
	pop		ax

	jmp		dword ptr cs:wektor8

	;zmienne
	kolor			db	1
	adres_piksela	dw	10
	przyrost		dw	0
	wektor8			dd	?


linia ENDP

zacznij:
	mov		ah, 0
	mov		al, 13h
	int		10h

	; zapamiêtanie wektora numer 8
	mov		bx, 0
	mov		es, bx	; zerowanie rejestru es
	mov		eax, es:[32] ; odczytanie wektora nr 8
	mov		cs:wektor8, eax ; zapamienianie wektora 8

	; adres procedury 'linia' w postaci segment:offset
	mov		ax, SEG linia
	mov		bx, OFFSET linia

	cli

	; zapisanie adresu procedury 'linia' do wektora nr 8
	mov		es:[32], bx
	mov		es:[34], ax

	sti

czekaj:
	mov		ah, 1
	int		16h
	jz		czekaj

	mov		ah, 0
	mov		al, 3h
	int		10h

	; odtworzenie oryginalnej wartoœci wektora 8
	mov		eax, cs:wektor8
	mov		es:[32], eax

	; zakoñczenie wykonywania
	mov		ax, 4c00h
	int		21h
rozkazy ENDS

stosik	SEGMENT stack
	db	256	dup	(?)
stosik	ENDS

END zacznij