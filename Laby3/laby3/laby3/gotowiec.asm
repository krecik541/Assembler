.686
.model flat
extern __write:PROC
extern __read:PROC
extern _ExitProcess@4:PROC
extern _MessageBoxW@16 : PROC

public _main

.data
wczyt	db	12	dup (?)
wynik	db	12	dup	(0)
magazyn	dw	12	dup	(20H)
tab		db	'0123456789ABCDEFGHIJKLMNOPQESTUVWXYZ'
tabw    dw  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
podstawa db	14
liczba1	dd	0	
.code
czysc_wynik	PROC
	pusha
	; czyszczenie zmiennej wynikowej
	mov		dword PTR wynik, 0
	mov		dword PTR wynik[4], 0
	mov		dword PTR wynik[8], 0
	popa
	ret
czysc_wynik	ENDP

wyswietl_EAX_precision PROC
	pusha
	
	call	czysc_wynik
	; ustawianie liczników
	mov		edi, 10 ; licznik 
	;mov		esi, 0 ; licznik odpowiedzialny za postawienia przecinka w odpowiednim miejscu
	mov		ebx, 10 ; podstawa dzielenia

konwersja:	mov		edx, 0 ; zeruje starsz¹ czêœæ liczby EDX:EAX
			div		ebx		; dzielê liczbê EDX:EAX przez EBX
			mov		dl, tab[edx] ; wartoœæ reszty -> znak ASCII odpowiadaj¹cy tej reszcie
			mov		wynik[edi], dl ; zapisanie liczby w pamiêci
			dec		edi		; zmniejszam licznik
			
			cmp		ecx, 0
			je		dalej
			dec		ecx
			cmp		ecx, 0 ; czy jest to odpowiednie miejsce na wstawienie przecinka
			jne		dalej
			mov		wynik[edi], '.'
			dec		edi
			cmp		eax, 0
			mov		wynik[edi], 30H
			
dalej:		cmp		eax, 0	
			jne		konwersja

			;dostawianie zer i przecinka
dalej1:		cmp		ecx, 0
			je		wypisz
			mov		wynik[edi], 30H
			dec		edi
			dec		ecx
			jnz		dalej1
			mov		wynik[edi], '.'
			mov		wynik[edi-1], 30H
	
wypisz:
	mov		wynik[11], 10
	; wypisanie liczby
	push	12
	push	OFFSET wynik
	push	1
	call	__write
	add		esp, 12
			
	popa
	ret
wyswietl_EAX_precision ENDP


wyswietl_eax_msgbox PROC
	pusha
	call	czysc_wynik
	; ustawianie liczników
	mov		edi, 10 ; licznik 
	movzx	ebx, podstawa ; podstawa dzielenia

konwersja:	mov		edx, 0 ; zeruje starsz¹ czêœæ liczby EDX:EAX
			div		ebx		; dzielê liczbê EDX:EAX przez EBX
			mov		cl, tab[edx] ; wartoœæ reszty -> znak ASCII odpowiadaj¹cy tej reszcie
			mov		magazyn[edi], cx ; zapisanie liczby w pamiêci
			sub		edi, 2		; zmniejszam licznik
			cmp		eax,0	
			jne		konwersja

	mov		wynik[0], 10
	mov		magazyn[11], 0

	; wypisanie liczby
	push	12
	push	OFFSET magazyn
	push	1
	call	__write
	add		esp, 12


	;wypisanie w messagebox
	push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	 push OFFSET magazyn
	; adres obszaru zawieraj¹cego tekst
	 push OFFSET magazyn
	 push 0 ; NULL
	 call _MessageBoxW@16
			
	popa
	ret
wyswietl_eax_msgbox ENDP

wczytaj_do_EAX PROC
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	
	; wczytanie liczby
	push	12 ; iloœæ znaków
	push	OFFSET wczyt ; adres w pamiêci
	push	0 ; klawiatura
	call	__read
	add		esp, 12

	; przygotowanie do konwersji
	movzx	ebx, podstawa ; podstawa systemu liczbowego
	mov		esi, 0			
	mov		eax, 0
	mov		ecx, 0
	
konwertuj:	mov		cl, wczyt[esi]
			cmp		cl, 10
			je		byl_enter
			inc		esi

			mul		ebx

			cmp		cl, '0'
			jb		konwertuj
			cmp		cl, '9'
			ja		duza_litera
			sub		cl, 30H
			jmp		wpisanie

duza_litera:cmp		cl, 'A'
			jb		konwertuj
			cmp		cl, 'Z'
			ja		mala_litera
			sub		cl, 41H - 10
			jmp		wpisanie

mala_litera:cmp		cl, 'a'
			jb		konwertuj
			cmp		cl, 'z'
			ja		konwertuj
			sub		cl, 'a' - 10

wpisanie:	add		eax, ecx
			jmp		konwertuj
			


byl_enter:
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	ret
wczytaj_do_EAX ENDP


_main PROC
	;mov		eax, 1234
	;call	wyswietl_EAX
	;call	wczytaj_do_EAX
	;call	wyswietl_EAX

	mov		eax, 15
	mov		cl, 1
	call	wyswietl_EAX_precision
	mov		cl, 2
	call	wyswietl_EAX_precision
	mov		cl, 3
	call	wyswietl_EAX_precision
	mov		cl, 4
	call	wyswietl_EAX_precision
	mov		cl, 5
	call	wyswietl_EAX_precision


	mov		eax, 138
	call	wyswietl_eax_msgbox

	push	0
	call	_ExitProcess@4
_main ENDP
END