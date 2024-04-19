.686
.model flat

extern	_GetSystemDirectoryA@8 : PROC
extern	_GetLocalTime@4 : PROC

public _szukaj4_max
public _plus_jeden
public _liczba_przeciwna
public _odejmij_jeden
public _bubble_sort
public najwieksza_liczba_STDCALL
public _dot_product
public _isPalindrome
public _dzielenie
public _check_system_dir
public _fibonacci
public _daj_czas

.code
_szukaj4_max PROC
	push	ebp
	mov		ebp, esp
	push	ebx

	; sprawdzam czy wiêksze jest a czy b
	mov		eax, [ebp + 8] ; przepisuje a do eax
	cmp		eax, [ebp + 12] ; porównuje a z b
	jg     b_mniejsze ; skok jeœli b nie jest wiêksze od a
	mov		eax, [ebp + 12] ; jeœli b jest wiêksze od a
b_mniejsze:
	
	; sprawdzam czy c jest wieksze od d
	mov		ecx, [ebp+16] ; przepisuje c do ecx
	cmp		ecx, [ebp+20] ; porównuje c z d
	jg		d_mniejsze ; skok jeœli d jest mnijesze lub równe c
	mov		ecx, [ebp+20] ; jeœli d jest wiêksze od c
d_mniejsze:

	; porównuje wiêksze liczby z obu par
	cmp		eax, ecx  ; porównuje max(a,b) i max(a,c)
	jg		koniec ; jeœli max(a,b) jest wiêkszy
	mov		eax, ecx ; jeœli max(c,d) jest wiêkszy
koniec:
	pop		ebx
	pop		ebp
	ret
_szukaj4_max ENDP

_plus_jeden PROC
	push	ebp
	mov		ebp, esp
	
	mov		eax, [ebp+8] ; wpisuje adres argumentu
	inc		dword PTR [eax] ; zwiêkszenie wartoœci zmiennej
	
	pop		ebp
	ret
_plus_jeden ENDP

_liczba_przeciwna PROC
	push	ebp
	mov		ebp, esp

	; wpisanie argumentu do eax
	mov		eax, [ebp+8]
	neg		eax

	pop		ebp
	ret
_liczba_przeciwna ENDP

_odejmij_jeden PROC
	push	ebp
	mov		ebp, esp
	push	ebx

	; pobieram adres wskaŸnika (&wsk)
	mov		ebx, [ebp+8]
	
	; pobieram wskaŸnik, ecx = wsk
	mov		ecx, [ebx]

	; zmieniam wartoœæ wskaŸnika
	dec		dword ptr [ecx]


	pop		ebx
	pop		ebp
	ret
_odejmij_jeden ENDP

_bubble_sort PROC
	push	ebp
	mov		ebp, esp
	push	edi
	push	esi
	push	ebx

	; adres tablicy w eax, n w ecx
	mov		ecx, [ebp+12] ; w ecx jest n
	mov		eax, [ebp+8] ; przepisuje adres t[0]
	lea		ecx, [eax + 4 * ecx] ; adres t[n]
	mov		edi, 0 ; j
	mov		esi, eax ; i

ptl:	
		mov		edi, esi ; j = i
	ptl1:	mov		edx, [esi] ; edx = t[i]
			cmp		edx, [edi] ; if (t[i] <= t[j])
			jng		dalej 
			xchg	edx, [edi] ; swap(t[i], t[j])
			mov		[esi], edx ; zapisanie t[i] w pamiêci
dalej:		add		edi, 4 ; j++
			cmp		edi, ecx ; j<n
			jb		ptl1
		add		esi, 4 ; i++
		cmp		esi, ecx ; i<n
		jb		ptl

	pop		ebx
	pop		esi
	pop		edi
	pop		ebp
	ret
_bubble_sort ENDP

najwieksza_liczba_STDCALL	 PROC stdcall, arg1:dword, arg2:dword, arg3:dword
	mov		eax, arg1	
	cmp		eax, arg2 ; if arg1 < arg2
	jg		arg1_wieksze
	mov		eax, arg2
arg1_wieksze:
	cmp		eax, arg3 ; if max(arg1, arg2) < arg3
	jg		dalej
	mov		eax, arg3
dalej:
	ret		12
najwieksza_liczba_STDCALL ENDP

_dot_product PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi


	; w rejestrze esi bêdzie tab1, w edi tab2, w ecx n
	mov		esi, [ebp+8] ; w esi znajduje siê wskaŸnik na tab1[0]
	mov		edi, [ebp+12] ; w edi znajduje siê wskaŸnik na tab2[0]
	mov		ecx, [ebp+16] ; w ecx znajduje siê n
	mov		ebx, 0	; suma iloczynu

ptl:	mov		eax, [esi] ; i-ty coœ tam tab1[]
		mul		dword ptr [edi] ; i-ty coœ tam tab2[]
		add		ebx, eax ; zapisanie mno¿enia i-tych elementów
		add		esi, 4 ; zwiêkszenie wskaŸnika tab1[]
		add		edi, 4 ; zwiêkszanie wskaŸnika tab2[]
		loop	ptl

	mov		eax, ebx

	pop		edi
	pop		esi
	pop		ebx
	pop		ebp
	ret
_dot_product ENDP

_isPalindrome PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	ebx
	
	; przpisanie zawartoœci parametrów do rejestrów
	mov		esi, [ebp+8] ; do esi przepisany jest adres pierwszej litery
	mov		ecx, [ebp+12] ; do ecx przepisana jest d³ugoœæ wyrazu
	lea		edx, [esi+ecx*2 - 2] ; adres koñca wyrazu

	
	; if (len == 0 || len == 1)
	jecxz	koniec ; jeœli ecx == 0 to zwracamy 1
	cmp		ecx, 1 ; jeœli ecx == 1 to zwracamy 1
	jnz		dalej


koniec:
	; return true
	mov		eax, 1 ; przypisanie wyniku
					; wyjœcie jeœli n == 0 || n == 1
	jmp		koniec_dalej ; trzeba pamiêtaæ ¿e tu nie mo¿e byæ ret, bo stos nie bêdzie wyrównany


dalej:
	; if(strng[i] != strng[koniec-i])
	mov		bx, [esi] ; element t[i] 
	cmp		bx, [edx] ; element t[i] == t[koniec - i]
	jz		rowne 


	; return false
	mov		eax, 0	; jeœli t[i] != t[koniec - i]
	jmp		koniec_dalej ; trzeba pamiêtaæ ¿e tu nie mo¿e byæ ret, bo stos nie bêdzie wyrównany


rowne:
	; return isPalindrome (strng[++i:koniec-i], len - 2)
	sub		ecx, 2 ; len -= 2
	add		esi, 2 ; i += 2
	push	ecx 
	push	esi
	call	_isPalindrome
	add		esp, 8 ; wyrównanie stosu

koniec_dalej:
	pop		ebx
	pop		esi
	pop		ebp
	ret
_isPalindrome ENDP

_dzielenie PROC
	push	ebp
	mov		ebp, esp

	; przypisanie parametrów do rejestrów
	mov		ecx, [ebp+8] ; adres dzielnej
	mov		eax, [ecx] ; dzielna
	mov		ecx, [ebp+12] ; adres wskaŸnika na dzielnik
	mov		edx, [ecx] ; adres dzielnika
	mov		ecx, [edx] ; dzielnik

	bt		eax, 31
	jnc		dalej_dzielenie
	mov		edx, 0FFFFFFFFH
	jmp		dzielenie
dalej_dzielenie:
	mov		edx, 0 ; zerowanie starszej czêœci z³o¿enia EDX:EAX
		
dzielenie:
	idiv	ecx ; dzielenie ze znakiem EDX:EAX przez ECX

	pop		ebp
	ret
_dzielenie ENDP
_check_system_dir PROC
	push	ebp
	mov		ebp, esp
	push	ebx

	
	sub		esp, 20 ; rezerwacja miejsca na zmienne lokalne
	mov		ebx, esp ; przypisanie adresu zmiennych lokalnych

	push	20 ; maksymalny rozmiar bufora
	push	ebx ; adres buforu
	call	_GetSystemDirectoryA@8
	
	; przepisanie argumentów
	mov		edx, [ebp+8] ; adres tablicy znaków
	; add		esp, 20 

	mov		ecx, eax ; liczba wprowadzonych znaków
ptl:	mov		al, [edx]		
		cmp		al, [ebx]
		jz		rowne
		mov		eax, 0 ; podany przez u¿ytkownika string nie jest folderem systemowym
		jmp		koniec
rowne:	inc		edx
		inc		ebx
		loop	ptl

	mov		eax, 1
koniec:
	add		esp, 20 
	pop		ebx
	pop		ebp
	ret
_check_system_dir ENDP

_fibonacci PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	ecx
	
	; przepisanie i ze stosu
	mov		esi, [ebp+8]

	; jeœli jest poni¿ej 2 ma zwracaæ 1
	cmp		esi, 2
	ja		dalejj
	cmp		esi, 0
	jnz		niezero
	mov		eax, 0
	jmp		koniecc
niezero:
	mov		eax, 1
	jmp		koniecc
dalejj:
	; jeœli jest powy¿ej 47 ma zwracaæ -1
	cmp		esi, 47
	jbe		dalejjj
	mov		eax, -1
	jmp		koniecc
dalejjj:
	
	mov		ecx, 0 ; wynik tymczasowy
	dec		esi ; i--

	
	push	esi
	call	_fibonacci ; fib(i-1)
	add		esp, 4 ; wyrównanie stosu


	add		ecx, eax ; temp_wynik = eax


	dec		esi ; i--
	push	esi
	call	_fibonacci ; fib(i-2)
	add		esp, 4 ; wyrównanie stosu

	add		eax, ecx ; wynik

koniecc:
	pop		ecx
	pop		esi
	pop		ebp
	ret
_fibonacci ENDP





_swap	PROC
	push	ebp
	mov		ebp, esp
	push	edi
	push	esi
	push	ebx

	; przepisanie parametrów 
	mov		esi, [ebp+8] ; wskaŸnik na tablice
	mov		edx, [ebp+12] ; n
	mov		ecx, [ebp+16] ; pos1
	mov		ebx, [ebp+20] ; pos2

	cmp		ecx, 0
	jb		nie_dziala
	cmp		ebx, 0
	jb		nie_dziala
	cmp		ecx, edx
	jae		nie_dziala
	cmp		ebx, edx
	jae		nie_dziala

	dec		ebx
	lea		esi, [esi + ecx*4]
	lea		edi, [esi + ebx*4]
	mov		eax, [edi]
	xchg	eax, [esi]
	mov		[edi], eax
	
	mov		eax, 1
	jmp		koniec_swap

nie_dziala:
	mov		eax, 0
koniec_swap:
	pop		ebx
	pop		esi
	pop		edi
	pop		ebp
	ret
_swap	ENDP



_daj_czas PROC
	push	ebp
	mov		ebp, esp

	sub		esp, 50
	push	ebx
	push	esi

	; wskaŸnik w esi
	mov		esi, [ebp+8]
	mov		ebx, esp ; przypisanie adresu zmiennych lokalnych

	push	ebx ; adres buforu
	call	_GetLocalTime@4
	; _GetSystemTime@4

	mov		al, [ebx+8]
	mov		[esi], al
	mov		al, [ebx+10]
	mov		[esi+1], al

	
	pop		ebx
	pop		esi
	add		esp, 50
	pop		ebp
	ret
_daj_czas ENDP
END