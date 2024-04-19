.686
.model flat

extern __write	: PROC
extern __read	: PROC
extern _ExitProcess@4 : PROC

public _main

.data
liczba	db	12 dup (?)
mnoznik	dd	10

.code
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


	push	0
	call	_ExitProcess@4

_main	ENDP
END