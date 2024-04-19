.686
.model flat
extern _ExitProcess@4	:	PROC
extern __write	:	PROC
extern __read	:	PROC

public _main

.data
tekst_pocz		db		10, 'Prosze napisac jakis tekst '
				db		'i nacisnac ENTER', 10
koniec_t		db		?
magazyn			db		80 dup (?)
nowa_linia		db		10
liczba_znakow	dd		?
informatyka		db		'innformatyka'


.code
_main PROC


		mov		cx, word ptr informatyka
		mov		cx, [ebp]
		mov		cx, [ecx]







		mov cx, word ptr tekst_pocz
		db		88h, 14h, 1ah
		mov		cx, [ebp]
		jmp		jebac_psy
		sub		bx, 256
		sub		bx, 256
		sub		bx, 256
jebac_psy:
		sub		bx, 256
		sub		bx, 256
		sub		bx, 256
		jmp		jebac_psy
		; wyœwietlanie tekstu informacyjnego

		; liczba znaków tekstu
		mov		ecx, OFFSET koniec_t - OFFSET tekst_pocz
		push	ecx
		push	OFFSET tekst_pocz
		push	1
		call	__write										; __write(uchwyt okna, pocz¹tek ci¹gu, iloœæ bajtów)
		add		esp, 12										; czyscimy stos

		sub		esp, 12

		; czytanie znaków z klawiatury
		push	80											; maksymalna iloœæ znaków
		push	esp								
		push	0											; nr urz¹dzenia (tu: klawiatura - nr 0)
		call	__read										; __read(numer urz¹dzenia, miejsce zapisu, maksymalna iloœæ zapisanych bajtów)
		add		esp, 12
		; funkcja read wpisuje do rejestru EAX liczbê wczytanych znaków
		mov		liczba_znakow, eax

		push	dword ptr 'innf'
		push	dword ptr 'orma'
		push	dword ptr 'tyka'

		push	dword ptr 0
		push	dword ptr informatyka
		push	dword ptr informatyka+4
		push	dword ptr informatyka+8

		sub		esp, 12

		mov		ebx, [esp-12+eax]

		; na eax jest liczba znaków
		mov		ecx, eax
		mov		ebx, 0										; indeks pocz¹tkowy

ptl1:	mov		dl, magazyn[ebx]							; pobieramy kolejny znak z "tablicy"
		cmp		dl, 'a'
		jb		dalej										; jeœli zawartoœæ dl < (int)'a'
		cmp		dl, 'z'										
		ja		dalej										; jeœli zawartoœæ dl > (int)'z'
		sub		dl, 20H										; zamiana na wielkie litery
		mov		magazyn[ebx], dl							; odes³anie litery do "tablicy"

dalej:	inc		ebx											; inkrementacja indeksu
		loop	ptl1										; sterowanie pêtl¹

		; wyœwietlanie przekszta³conego tekstu
		push	liczba_znakow
		push	OFFSET magazyn
		push	1
		call	__write										; wyœwietlenie przekszta³conego tekstu
		add		esp, 12

		
		push	0
		call	_ExitProcess@4
_main ENDP
END