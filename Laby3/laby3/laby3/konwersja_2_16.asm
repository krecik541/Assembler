.686
.model flat

extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data
liczba				db	12 dup (?) ; wczytana liczba
liczba_wyswietlana	db	12 dup (0) ; wyœwietlana liczba
tab					db	'0123456789ABCDEF'
.code
wyswietl_EAX	PROC
	pusha

	mov		esi, 10 ; ustawiam licznik
	mov		ebx, 10 ; ustawiam mnoznik

konwersja:	mov		edx, 0 ; zeruje starsz¹ czêœæ dzielonej liczby
			div		ebx ; dzielê liczbê EDX:EAX przez EBX
			mov		cl, tab[edx] ; w EDX znajduje siê reszta z dzielenia, która bêdzie odpowiada³a swojej reprezentacji w tablicy
			mov		liczba_wyswietlana[esi], cl ; przes³anie reprezentacji znaku do magazynu
			dec		esi
			cmp		eax, 0
			jne		konwersja

	; wyœwietlenie liczby
	push	12
	push	OFFSET liczba_wyswietlana
	push	1
	call	__write
	add		esp, 12

	popa
	ret
wyswietl_EAX	ENDP





wczytaj_do_EAX	PROC
	mov		eax, 0
	mov		ecx, 0
	mov		esi, 0
	mov		ebx, 10

konwersja1: mov		cl, liczba[esi]
			cmp		cl, 10
			je		byl_enter
			sub		cl, 30H

			mul		ebx
			add		eax, ecx
			inc		esi
			jmp		konwersja1

byl_enter:
	ret
wczytaj_do_EAX	ENDP




wyswietl_EAX_hex	PROC
	pusha

	; rezerwuje miejsce na stosie na tymczasowe zmienne
	sub		esp, 12
	mov		edi, esp ; adres zarezerwowanej pamiêci

	; przygotowanie konwersji
	mov		ecx, 8	; liczba obiegów pêtli (liczba bitów w liczbie)
	mov		esi, 1	; indeks pocz¹tkowy u¿ywany przy zapisie liczby 

ptlHex:		rol		eax, 4 ; przesuwa bity o wybran¹ iloœæ bitów w lewo; najstarsze bity staj¹ siê najm³odszymi

			mov		ebx, eax
			and		ebx, 0000000FH ; porównanie bitowe; zeruje bity 31 - 4 w rejestrze EBX
			mov		dl, tab[ebx]

			mov		[edi][esi], dl

			inc		esi
			loop	ptlHex

	; dodawanie nowej linii 
	mov		byte PTR [edi][0], 30H
	mov		byte PTR [edi][9], 0


	; usuwanie nieznacz¹cych zer z lewej strony liczby
	mov		esi, 0 ; zaczynam od lewej strony liczby
	mov		ecx, 8 ; maksymalna iloœæ bajtów liczby

spacje:		mov		dl, [edi][esi]
			cmp		dl, 30H
			jne		wyjscie ; jeœli natrafimy na pierwszy niezerowy bajt
			mov		dl, 0
			mov		[edi][esi], dl
			inc		esi
			jmp		spacje
			
wyjscie:

	;wyœwietlanie
	push	10
	push	edi
	push	1
	call	__write
	add		esp, 24 ; 12 z wy¿ej zarezerwowanego + 12 z write


	popa
	ret
wyswietl_EAX_hex	ENDP


wczytaj_do_EAX_hex	PROC
	push	esi
	push	ebx
	push	edx
	push	ecx
	push	edi
	push	ebp


	; rezerwacja miejsca na stosie
	sub		esp, 12
	mov		esi, esp ; wskaŸnik na zarezerwowane miejsce na stosie

	; wczytanie liczby
	push	10	; liczba znaków
	push	esi	; miejsce zarezerwowane na stosie
	push	0 ; klawiatura
	call	__read
	add		esp, 12

	; konwersja wczytanej liczby
	mov		eax, 0	; zerujemy wynik
	mov		edx, 0 ; tu bêdziemy wczytywaæ, a póŸniej modyfikowaæ cyfrê

ptl3hex:	mov		dl, [esi]
			inc		esi
			cmp		dl, 10 ; jeœli natrafimy na enter nale¿y zakoñczyæ konwersjê
			je		koniec

			; sprawdzamy, czy natrafiono na cyfrê
			cmp		dl, '0'
			jb		ptl3hex ; ignorujemy znaki nie nale¿¹ce do przedia³u '0-9'
			cmp		dl, '9'
			ja		dalej	; dany znak nie jest cyfr¹, ale mo¿e byæ znakiem
			sub		dl, '0'  ; natrafiony znak jest cyfr¹, wiêc odejmujemy od jego kodu ASCII kod ASCII '0'
			jmp		znaleziono

dalej:		; sprawdzamy, czy natrafiono na du¿¹ literê
			cmp		dl, 'A'
			jb		ptl3hex ; ignorujemy znaki nie nale¿¹ce do przedia³u 'A-F'
			cmp		dl, 'F'
			ja		dalej1	; dany znak nie jest ma³¹ liter¹, ale mo¿e byæ du¿¹
			sub		dl, 'A'-10  ; natrafiony znak jest ma³¹ liter¹, wiêc odejmujemy od jego kodu ASCII kod ASCII 'a'
			jmp		znaleziono

dalej1:		; sprawdzamy, czy natrafiono na ma³¹ literê
			cmp		dl, 'a'
			jb		ptl3hex ; ignorujemy znaki nie nale¿¹ce do przedia³u 'a-f'
			cmp		dl, 'f'
			ja		ptl3hex	; dany znak nie jest ma³¹ liter¹, ale mo¿e byæ du¿¹
			sub		dl, 'a'-10  ; natrafiony znak jest ma³¹ liter¹, wiêc odejmujemy od jego kodu ASCII kod ASCII 'a'
			

			
znaleziono:  
			shl		eax, 4
			or		al, dl
			jmp		ptl3hex


koniec:

	add		esp, 12
	pop		ebp
	pop		edi
	pop		ecx
	pop		edx
	pop		ebx
	pop		esi
	ret
wczytaj_do_EAX_hex	ENDP

_main	PROC
	; wczytywanie liczby
	push	12 ; maksymalnie 12 znaków
	push	OFFSET	liczba	; adres magazynu
	push	0	; 0 - klawiatura
	call	__read
	add		esp, 12

	; mov		eax, 1234
	; call	wyswietl_EAX

	;mov		eax, dword PTR liczba
	;call	wczytaj_do_EAX
	;
	;call	wyswietl_EAX_hex

	call	wczytaj_do_EAX_hex
	mov		eax, 4d2H
	call	wyswietl_EAX



	push	0
	call	_ExitProcess@4
_main	ENDP
END

; wyœwietl_EAX - mam w pamiêci liczbê w postaci 2 (lub 16) i wypisuje j¹ w 10
; wczytaj_do_EAX - pobieram z klawiatury liczbê w postaci 10 i konwertuje j¹ na 2 (lub 16)
; wyœwietl_EAX_hex - mam w pamiêci liczbê w postaci 2 (lub 16) i wypisuje j¹ w 16
; wczytaj_do_EAX_hex  - pobieram z klawiatury liczbê w postaci 16  i konwertuje j¹ na 2 (lub 16)