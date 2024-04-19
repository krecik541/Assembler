.386
rozkazy SEGMENT use16
		ASSUME  CS:rozkazy

; podprogram 'wyswietl_AL' wyœwietla zawartoœæ rejestru AL
; w postaci liczby dziesiêtnej bez znaku
wyswietl_AL PROC
	; wyœwietlanie zawartoœci rejestru AL na ekranie wg adresu
	; podanego w ES:BX
	; stosowany jest bezpoœredni zapis do pamiêci ekranu
	; przechowanie rejestrów
	push ax
	push cx
	push dx
	
	mov cl, 10 ; dzielnik

	mov ah, 0 ; zerowanie starszej czêœci dzielnej
	; dzielenie liczby w AX przez liczbê w CL, iloraz w AL,
	; reszta w AH (tu: dzielenie przez 10)
	div cl
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+4], ah ; cyfra jednoœci
	
	mov ah, 0
	div cl ; drugie dzielenie przez 10
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+2], ah ; cyfra dziesi¹tek
	
	add al, 30H ; zamiana na kod ASCII
	mov es:[bx+0], al ; cyfra setek
	
	; wpisanie kodu koloru (intensywny bia³y) do pamiêci ekranu
	mov al, 00001111B
	mov es:[bx+1],al
	mov es:[bx+3],al
	mov es:[bx+5],al
	
	; odtworzenie rejestrów
	pop dx
	pop cx
	pop ax
	ret ; wyjœcie z podprogramu
wyswietl_AL ENDP


obsluga_klawy PROC
	push	ax
	push	bx
	push	es

	mov		ax, 0b800h ; adres pamiêci ekranu (*16)
	mov		es, ax

	mov		bx, cs:licznik

	in		al, 60h
	call	wyswietl_AL

	; add		bx, 8

	cmp		bx, 4000
	jb		wyswietl_dalej

	mov		bx, 0

wyswietl_dalej:
	mov		cs:licznik, bx

	pop		es
	pop		bx
	pop		ax

	jmp		dword ptr cs:wektor9

	; dane
	wektor9 dd	?
	licznik	dw	320
obsluga_klawy ENDP

; ===================================

zacznij:
	mov		al, 0
	mov		al, 5
	int		10

	mov		ax, 0
	mov		ds, ax		; zerowanie rejestru DS

	; wektor9 = 9 * 4 + 0
	mov		eax, ds:[36]
	mov		cs:wektor9, eax

	; wpisanie adresu procedury do wektora nr 9
	mov		ax, SEG obsluga_klawy
	mov		bx, OFFSET obsluga_klawy

	cli ; zablokowanie przerwañ

	; zapisanie adresu procedury do wektora nr 9
	mov		ds:[36], bx
	mov		ds:[38], ax

	sti ; odblokowanie przerwañ


	; main loop do esc
oczekiwanie:
	mov		ah, 1
	int		16h
	jz		oczekiwanie
	
	; odczytwywanie numeru klawisza wciœniêtegogo klawisza
	mov		ah, 0
	int		16h
	cmp		ah, 1
	jne		oczekiwanie

	; deinstalacja procedury obs³ugi przerwnia 
	mov		eax, cs:wektor9
	cli
	mov		ds:[36], eax ; przes³anie oryginalenej wartoœci do wektora 9 w tablicy przerwañ
	
	sti

	; zakoñczenie programu
	mov		al, 0
	mov		ah, 4ch
	int		21h
rozkazy ENDS

nasz_stos SEGMENT stack
	db	128 dup (?)
nasz_stos ENDS

END zacznij

