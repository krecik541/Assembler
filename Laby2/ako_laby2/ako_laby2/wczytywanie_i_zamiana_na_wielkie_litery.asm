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
		; wy�wietlanie tekstu informacyjnego

		; liczba znak�w tekstu
		mov		ecx, OFFSET koniec_t - OFFSET tekst_pocz
		push	ecx
		push	OFFSET tekst_pocz
		push	1
		call	__write										; __write(uchwyt okna, pocz�tek ci�gu, ilo�� bajt�w)
		add		esp, 12										; czyscimy stos

		sub		esp, 12

		; czytanie znak�w z klawiatury
		push	80											; maksymalna ilo�� znak�w
		push	esp								
		push	0											; nr urz�dzenia (tu: klawiatura - nr 0)
		call	__read										; __read(numer urz�dzenia, miejsce zapisu, maksymalna ilo�� zapisanych bajt�w)
		add		esp, 12
		; funkcja read wpisuje do rejestru EAX liczb� wczytanych znak�w
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

		; na eax jest liczba znak�w
		mov		ecx, eax
		mov		ebx, 0										; indeks pocz�tkowy

ptl1:	mov		dl, magazyn[ebx]							; pobieramy kolejny znak z "tablicy"
		cmp		dl, 'a'
		jb		dalej										; je�li zawarto�� dl < (int)'a'
		cmp		dl, 'z'										
		ja		dalej										; je�li zawarto�� dl > (int)'z'
		sub		dl, 20H										; zamiana na wielkie litery
		mov		magazyn[ebx], dl							; odes�anie litery do "tablicy"

dalej:	inc		ebx											; inkrementacja indeksu
		loop	ptl1										; sterowanie p�tl�

		; wy�wietlanie przekszta�conego tekstu
		push	liczba_znakow
		push	OFFSET magazyn
		push	1
		call	__write										; wy�wietlenie przekszta�conego tekstu
		add		esp, 12

		
		push	0
		call	_ExitProcess@4
_main ENDP
END