.686
.model flat

extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data
liczba				db	12 dup (?) ; wczytana liczba
liczba_wyswietlana	db	12 dup (0) ; wy�wietlana liczba
tab					db	'0123456789ABCDEF'
.code
wyswietl_EAX	PROC
	pusha

	mov		esi, 10 ; ustawiam licznik
	mov		ebx, 10 ; ustawiam mnoznik

konwersja:	mov		edx, 0 ; zeruje starsz� cz�� dzielonej liczby
			div		ebx ; dziel� liczb� EDX:EAX przez EBX
			mov		cl, tab[edx] ; w EDX znajduje si� reszta z dzielenia, kt�ra b�dzie odpowiada�a swojej reprezentacji w tablicy
			mov		liczba_wyswietlana[esi], cl ; przes�anie reprezentacji znaku do magazynu
			dec		esi
			cmp		eax, 0
			jne		konwersja

	; wy�wietlenie liczby
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
	mov		edi, esp ; adres zarezerwowanej pami�ci

	; przygotowanie konwersji
	mov		ecx, 8	; liczba obieg�w p�tli (liczba bit�w w liczbie)
	mov		esi, 1	; indeks pocz�tkowy u�ywany przy zapisie liczby 

ptlHex:		rol		eax, 4 ; przesuwa bity o wybran� ilo�� bit�w w lewo; najstarsze bity staj� si� najm�odszymi

			mov		ebx, eax
			and		ebx, 0000000FH ; por�wnanie bitowe; zeruje bity 31 - 4 w rejestrze EBX
			mov		dl, tab[ebx]

			mov		[edi][esi], dl

			inc		esi
			loop	ptlHex

	; dodawanie nowej linii 
	mov		byte PTR [edi][0], 30H
	mov		byte PTR [edi][9], 0


	; usuwanie nieznacz�cych zer z lewej strony liczby
	mov		esi, 0 ; zaczynam od lewej strony liczby
	mov		ecx, 8 ; maksymalna ilo�� bajt�w liczby

spacje:		mov		dl, [edi][esi]
			cmp		dl, 30H
			jne		wyjscie ; je�li natrafimy na pierwszy niezerowy bajt
			mov		dl, 0
			mov		[edi][esi], dl
			inc		esi
			jmp		spacje
			
wyjscie:

	;wy�wietlanie
	push	10
	push	edi
	push	1
	call	__write
	add		esp, 24 ; 12 z wy�ej zarezerwowanego + 12 z write


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
	mov		esi, esp ; wska�nik na zarezerwowane miejsce na stosie

	; wczytanie liczby
	push	10	; liczba znak�w
	push	esi	; miejsce zarezerwowane na stosie
	push	0 ; klawiatura
	call	__read
	add		esp, 12

	; konwersja wczytanej liczby
	mov		eax, 0	; zerujemy wynik
	mov		edx, 0 ; tu b�dziemy wczytywa�, a p�niej modyfikowa� cyfr�

ptl3hex:	mov		dl, [esi]
			inc		esi
			cmp		dl, 10 ; je�li natrafimy na enter nale�y zako�czy� konwersj�
			je		koniec

			; sprawdzamy, czy natrafiono na cyfr�
			cmp		dl, '0'
			jb		ptl3hex ; ignorujemy znaki nie nale��ce do przedia�u '0-9'
			cmp		dl, '9'
			ja		dalej	; dany znak nie jest cyfr�, ale mo�e by� znakiem
			sub		dl, '0'  ; natrafiony znak jest cyfr�, wi�c odejmujemy od jego kodu ASCII kod ASCII '0'
			jmp		znaleziono

dalej:		; sprawdzamy, czy natrafiono na du�� liter�
			cmp		dl, 'A'
			jb		ptl3hex ; ignorujemy znaki nie nale��ce do przedia�u 'A-F'
			cmp		dl, 'F'
			ja		dalej1	; dany znak nie jest ma�� liter�, ale mo�e by� du��
			sub		dl, 'A'-10  ; natrafiony znak jest ma�� liter�, wi�c odejmujemy od jego kodu ASCII kod ASCII 'a'
			jmp		znaleziono

dalej1:		; sprawdzamy, czy natrafiono na ma�� liter�
			cmp		dl, 'a'
			jb		ptl3hex ; ignorujemy znaki nie nale��ce do przedia�u 'a-f'
			cmp		dl, 'f'
			ja		ptl3hex	; dany znak nie jest ma�� liter�, ale mo�e by� du��
			sub		dl, 'a'-10  ; natrafiony znak jest ma�� liter�, wi�c odejmujemy od jego kodu ASCII kod ASCII 'a'
			

			
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
	push	12 ; maksymalnie 12 znak�w
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

; wy�wietl_EAX - mam w pami�ci liczb� w postaci 2 (lub 16) i wypisuje j� w 10
; wczytaj_do_EAX - pobieram z klawiatury liczb� w postaci 10 i konwertuje j� na 2 (lub 16)
; wy�wietl_EAX_hex - mam w pami�ci liczb� w postaci 2 (lub 16) i wypisuje j� w 16
; wczytaj_do_EAX_hex  - pobieram z klawiatury liczb� w postaci 16  i konwertuje j� na 2 (lub 16)