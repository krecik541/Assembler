.686
.model flat

extern __write	: PROC
extern __read	: PROC
extern _ExitProcess@4 : PROC

public _main

.data
liczba	db	12 dup (?) ; liczba wczytywana
mnoznik	dd	10
znaki	db	12 dup (0) ; liczba wypisywana
.code
wyswietl_EAX PROC
	pusha
	mov		esi, 10	; liczba cyfr
	mov		ebx, 10	; dzielnik

konwersja:	mov		edx, 0	; starsze bity dzielnej
			div		ebx		; dziele EDX:EAX przez EBX
			add		edx, 30H ; w EDX znajduje siê reszta z dzielenia, tworzê z tej reszty ten sam znak w ASCII
			mov		znaki[esi], dl ; przesylam znak do tablicy
			dec		esi	
			cmp		eax, 0
			jne		konwersja

wypelnij:	cmp		esi, 0
			je		wyswietl
			mov		byte PTR znaki[esi], 0H ; zamiast 0 bêd¹ spacje
			dec		esi
			jmp		wypelnij

wyswietl:

	; mov		znaki[0], 0
	; mov		znaki[11], 20H


	; wyœwietlanie
	push	12
	push	OFFSET znaki
	push	1
	call	__write
	add		esp, 12

	popa
	ret
wyswietl_EAX ENDP

wczytaj_do_EAX	PROC
	; konwersja
	mov		eax, 0
	mov		esi, 0
	mov		ebx, 0

konwersja:	mov		bl, [liczba + esi]	; przesy³am kod ASCII cyfry
			cmp		bl, 0AH				; jeœli kod = enter
			je		ente				; skok, gdy wciœniety zosta³ enter
			sub		bl, 30H				; kod ascii liczby -> liczba

			mul		dword PTR mnoznik	; (x0*10 + x1) * 10 + x2 ...
			add		eax, ebx			; dodanie ostatnio odczytanej cyfry				
			inc		esi
			jmp		konwersja
ente:
	ret
wczytaj_do_EAX	ENDP
_main	PROC

	; wczytanie liczby
	push	12	; maks. rozmiar liczby
	push	OFFSET liczba	; adres magazynu
	push	0	; 0 - klawiatura
	call	__read
	add		esp, 12

	call	wczytaj_do_EAX
	mov		edx, 0
	mul		eax
	call	wyswietl_EAX


	push	0
	call	_ExitProcess@4

_main	ENDP
END