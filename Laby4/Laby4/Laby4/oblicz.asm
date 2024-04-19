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

	; sprawdzam czy wi�ksze jest a czy b
	mov		eax, [ebp + 8] ; przepisuje a do eax
	cmp		eax, [ebp + 12] ; por�wnuje a z b
	jg     b_mniejsze ; skok je�li b nie jest wi�ksze od a
	mov		eax, [ebp + 12] ; je�li b jest wi�ksze od a
b_mniejsze:
	
	; sprawdzam czy c jest wieksze od d
	mov		ecx, [ebp+16] ; przepisuje c do ecx
	cmp		ecx, [ebp+20] ; por�wnuje c z d
	jg		d_mniejsze ; skok je�li d jest mnijesze lub r�wne c
	mov		ecx, [ebp+20] ; je�li d jest wi�ksze od c
d_mniejsze:

	; por�wnuje wi�ksze liczby z obu par
	cmp		eax, ecx  ; por�wnuje max(a,b) i max(a,c)
	jg		koniec ; je�li max(a,b) jest wi�kszy
	mov		eax, ecx ; je�li max(c,d) jest wi�kszy
koniec:
	pop		ebx
	pop		ebp
	ret
_szukaj4_max ENDP

_plus_jeden PROC
	push	ebp
	mov		ebp, esp
	
	mov		eax, [ebp+8] ; wpisuje adres argumentu
	inc		dword PTR [eax] ; zwi�kszenie warto�ci zmiennej
	
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

	; pobieram adres wska�nika (&wsk)
	mov		ebx, [ebp+8]
	
	; pobieram wska�nik, ecx = wsk
	mov		ecx, [ebx]

	; zmieniam warto�� wska�nika
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
			mov		[esi], edx ; zapisanie t[i] w pami�ci
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


	; w rejestrze esi b�dzie tab1, w edi tab2, w ecx n
	mov		esi, [ebp+8] ; w esi znajduje si� wska�nik na tab1[0]
	mov		edi, [ebp+12] ; w edi znajduje si� wska�nik na tab2[0]
	mov		ecx, [ebp+16] ; w ecx znajduje si� n
	mov		ebx, 0	; suma iloczynu

ptl:	mov		eax, [esi] ; i-ty co� tam tab1[]
		mul		dword ptr [edi] ; i-ty co� tam tab2[]
		add		ebx, eax ; zapisanie mno�enia i-tych element�w
		add		esi, 4 ; zwi�kszenie wska�nika tab1[]
		add		edi, 4 ; zwi�kszanie wska�nika tab2[]
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
	
	; przpisanie zawarto�ci parametr�w do rejestr�w
	mov		esi, [ebp+8] ; do esi przepisany jest adres pierwszej litery
	mov		ecx, [ebp+12] ; do ecx przepisana jest d�ugo�� wyrazu
	lea		edx, [esi+ecx*2 - 2] ; adres ko�ca wyrazu

	
	; if (len == 0 || len == 1)
	jecxz	koniec ; je�li ecx == 0 to zwracamy 1
	cmp		ecx, 1 ; je�li ecx == 1 to zwracamy 1
	jnz		dalej


koniec:
	; return true
	mov		eax, 1 ; przypisanie wyniku
					; wyj�cie je�li n == 0 || n == 1
	jmp		koniec_dalej ; trzeba pami�ta� �e tu nie mo�e by� ret, bo stos nie b�dzie wyr�wnany


dalej:
	; if(strng[i] != strng[koniec-i])
	mov		bx, [esi] ; element t[i] 
	cmp		bx, [edx] ; element t[i] == t[koniec - i]
	jz		rowne 


	; return false
	mov		eax, 0	; je�li t[i] != t[koniec - i]
	jmp		koniec_dalej ; trzeba pami�ta� �e tu nie mo�e by� ret, bo stos nie b�dzie wyr�wnany


rowne:
	; return isPalindrome (strng[++i:koniec-i], len - 2)
	sub		ecx, 2 ; len -= 2
	add		esi, 2 ; i += 2
	push	ecx 
	push	esi
	call	_isPalindrome
	add		esp, 8 ; wyr�wnanie stosu

koniec_dalej:
	pop		ebx
	pop		esi
	pop		ebp
	ret
_isPalindrome ENDP

_dzielenie PROC
	push	ebp
	mov		ebp, esp

	; przypisanie parametr�w do rejestr�w
	mov		ecx, [ebp+8] ; adres dzielnej
	mov		eax, [ecx] ; dzielna
	mov		ecx, [ebp+12] ; adres wska�nika na dzielnik
	mov		edx, [ecx] ; adres dzielnika
	mov		ecx, [edx] ; dzielnik

	bt		eax, 31
	jnc		dalej_dzielenie
	mov		edx, 0FFFFFFFFH
	jmp		dzielenie
dalej_dzielenie:
	mov		edx, 0 ; zerowanie starszej cz�ci z�o�enia EDX:EAX
		
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
	
	; przepisanie argument�w
	mov		edx, [ebp+8] ; adres tablicy znak�w
	; add		esp, 20 

	mov		ecx, eax ; liczba wprowadzonych znak�w
ptl:	mov		al, [edx]		
		cmp		al, [ebx]
		jz		rowne
		mov		eax, 0 ; podany przez u�ytkownika string nie jest folderem systemowym
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

	; je�li jest poni�ej 2 ma zwraca� 1
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
	; je�li jest powy�ej 47 ma zwraca� -1
	cmp		esi, 47
	jbe		dalejjj
	mov		eax, -1
	jmp		koniecc
dalejjj:
	
	mov		ecx, 0 ; wynik tymczasowy
	dec		esi ; i--

	
	push	esi
	call	_fibonacci ; fib(i-1)
	add		esp, 4 ; wyr�wnanie stosu


	add		ecx, eax ; temp_wynik = eax


	dec		esi ; i--
	push	esi
	call	_fibonacci ; fib(i-2)
	add		esp, 4 ; wyr�wnanie stosu

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

	; przepisanie parametr�w 
	mov		esi, [ebp+8] ; wska�nik na tablice
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

	; wska�nik w esi
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