.686
.model flat
extern	__write	: PROC
extern	__read	: PROC
extern	_ExitProcess@4	: PROC

public	_main

.data
liczba	db	12 dup (?) ; tu znajduje siê wczytana liczba
wynik	db	12 dup (?) ; tu znajduje siê wynik
kon		db	'0123456789ABCDE'
podstawa db	16
minus	db	'-'
.code
wyswietl_EAX_13	PROC
	pusha

	; przygotowanie do konwersji
	movzx	ebx, podstawa ; podstawa systemu na któy konwertujemy liczbê
	mov		edi, 10 ; liczba obiegów pêtli i jednoczeœnie indeks
	
	; konwersja
konwertuj:	mov		edx, 0 ; zeruje starsz¹ czêœæ dzielonej liczby
			div		ebx ; dzielê liczbê EDX:EAX przez EBX
			cmp		dl, 10 ; nie zostanie wyœwietlona cyfra a litera
			jae		litera
			add		dl, 30H ; zwiêkszam tak ¿eby otrzymaæ kod ASCII danej liczby
			jmp		konw_dalej
litera:		add		dl, 'A'-10 ; zwiêkszam tak ¿eby otrzymaæ kod ASCII danej litery
konw_dalej:	mov		wynik[edi], dl ; w EDX znajduje siê reszta z dzielenia, zapisuje j¹ do wyniku
			dec		edi
			cmp		eax, 0
			jne		konwertuj

	mov		wynik[0], 0
	mov		wynik[11], 0

	; wypisywanie
	push	12
	push	OFFSET wynik
	push	1
	call	__write
	add		esp, 12

	popa
	ret
wyswietl_EAX_13	ENDP





wczytaj_do_EAX_13	PROC
	; wczytanie liczby
	push	10
	push	OFFSET liczba
	push	0
	call	__read
	add		esp, 12

	; przygotowanie do konwersji
	movzx	ebx, podstawa ; podstawa systemu liczbowego
	mov		esi, 0	; licznik
	mov		eax, 0 ; wynik
	mov		ecx, 0
	sub		esp, 4

konwersja:	mov		cl, liczba[esi]
			inc		esi
			cmp		cl, 10 ; sprawdzam czy natrafiony znak to ENTER
			je		wykryto_enter

			mul		ebx
			cmp		cl, '-'
			jne		moze_liczba
			mov		[edi], cl
			jmp		konwersja
moze_liczba:cmp		cl, '0'
			jb		konwersja
			cmp		cl, '9'
			ja		moze_litera
			sub		cl, 30H ; jeœli to jest liczba
			jmp		dalej_ko
moze_litera:cmp		cl, 'A'
			jb		konwersja
			cmp		cl, 'F'
			ja		mozeLitera1
			sub		cl, 'A'-10 ; jeœli to jest du¿a litera
			jmp		dalej_ko
mozeLitera1:cmp		cl, 'a'
			jb		konwersja
			cmp		cl, 'f'
			ja		konwersja
			sub		cl, 'a'-10 ; jeœli to jest du¿a litera
dalej_ko:	add		eax, ecx
			jne		konwersja
				
wykryto_enter:
	
	cmp		byte ptr [edi], '-'
	jne		dodatnia
	neg		eax
dodatnia:
	add		esp, 4
	ret
wczytaj_do_EAX_13	ENDP





wyswietl_EAX_U2	PROC
	pusha
	mov		ebx, 0
	bt		eax, 31	; sprawdzam czy najstarszy bit to 1, wtedy liczba jest ujemna
	;adc		ebx, 0 ; bit test zapisuje wartoœæ bitu w CF, wiêc sprawdzam zawartoœæ dodaj¹c do 0
	;or		ebx, ebx ; sprawdzam czy CF jest równe zero
	;jz		liczba_jest_dodatnia
	jnc		liczba_jest_dodatnia
	mov		ebx, eax ; pod wp³ywem call __write eax zostanie zmienione na 1??????
	; wypisanie minusa
	push	1
	push	OFFSET minus
	push	1
	call	__write
	add		esp, 12

	mov		eax, ebx ; wracam prawdziw¹ wartoœæ eax
	neg		eax ; zmieniam z u2 na nkb

liczba_jest_dodatnia:
	movzx	ebx, podstawa ; podstawa systemu liczbowego
	mov		edi, 10 ; licznik pêtli

konweeertuj:mov		edx, 0 ; starsza czêœæ liczby EDX:EAX
			div		ebx ; dzielê EDX:EAX przez EBX
			mov		cl, kon[edx] ; w edx znajduje siê reszta z dzielenia, kon[edx] to kod ASCII tej reszty
			mov		wynik[edi], cl ; zapisuje wynik
			dec		edi 
			cmp		eax, 0
			jne		konweeertuj


	; wypisanie liczby
	push	12
	push	OFFSET wynik
	push	1
	call	__write
	add		esp, 12

	popa
	ret
wyswietl_EAX_U2	ENDP


_main	PROC


	mov		eax, 1234
	call	wczytaj_do_EAX_13
	call	wyswietl_EAX_U2	

	

	push	0
	call	_ExitProcess@4
_main	ENDP
END