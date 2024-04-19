.686
.model flat
extern __write:PROC
extern __read:PROC
extern _ExitProcess@4:PROC

public _main

.data
wczyt	db	12	dup (?)
wynik	db	12	dup	(0)
tab		db	'0123456789ABCDEFGHIJKLMNOPQESTUVWXYZ'
podstawa db	13
.code
wyswietl_EAX PROC
	pusha
	; ustawianie liczników
	mov		edi, 10 ; licznik 
	movzx	ebx, podstawa ; podstawa dzielenia

konwersja:	mov		edx, 0 ; zeruje starsz¹ czêœæ liczby EDX:EAX
			div		ebx		; dzielê liczbê EDX:EAX przez EBX
			mov		cl, tab[edx] ; wartoœæ reszty -> znak ASCII odpowiadaj¹cy tej reszcie
			mov		wynik[edi], cl ; zapisanie liczby w pamiêci
			dec		edi		; zmniejszam licznik
			cmp		eax,0	
			jne		konwersja

	; wypisanie liczby
	push	12
	push	OFFSET wynik
	push	1
	call	__write
	add		esp, 12
			
	popa
	ret
wyswietl_EAX ENDP

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
	mov		eax, 1234
	call	wyswietl_EAX
	call	wczytaj_do_EAX
	call	wyswietl_EAX

	push	0
	call	_ExitProcess@4
_main ENDP
END