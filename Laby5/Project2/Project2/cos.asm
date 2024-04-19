.686
.XMM
.model flat

extern	_ExitProcess@4:PROC

public _pierwiastki_rownania_kwadratowego_przyklad1
public _srednia_harm
public _nowy_exp
public _dodaj_SSE
public _pierwiastek_SSE
public _odwrotnosc_SSE
public _suma_char
public _int2float
public _pm_jeden
public _dodawanie_SSE


public _find_max_range

public _mul_at_once


.data
; 2x^2 - x - 15 = 0
ALIGN 16
tabl_A	dd		1.0, 2.0, 3.0, 4.0
tabl_B	dd		2.0, 3.0, 4.0, 5.0
liczba db		1
tabl_C	dd		3.0, 4.0, 5.0, 6.0
wsp_a	dd		+2.0
wsp_b	dd		-1.0
wsp_c	dd		-15.0

dwa		dd		2.0
cztery	dd		4.0
x1		dd		?
x2		dd		?

jeden	dd		1.0
grav	dd		9.81
tab		dd		-1.0, -1.0, -1.0, -1.0
.code
_pierwiastki_rownania_kwadratowego_przyklad1 PROC
	push	ebp
	mov		ebp, esp

	; b^2 - 4ac
	fld		dword ptr wsp_a ; wrzucam wspó³czynnik a na wierzcho³ek stosu koprocesora
	fld		dword ptr wsp_c ; wrzucam wspó³czynnik c na wierzcho³ek stosu koprocesora
	fld		dword ptr cztery; wrzucam liczbê 4 na wierzcho³ek stosu koprocesora
	fmulp					; mno¿ê 4 * c i usuwam st(0), st(1) = 4c
	fmulp					; mno¿ê 4c * a i usuwam st(0), st(1) = 4ac

	fld		dword ptr wsp_b	; wrzucam wspó³czynnik b na wierzcho³ek stosu koprocesora
	fmul	st(0), st(0)	; mno¿ê b * b

	fsub	st(0), st(1)	; odejmuje st(0)-st(1) -> b^2 - 4ac
	; teraz na wierzcho³ku stosu koprocesora znadjue siê delta

	; sprawdzam (delta ? 0)
	fldz		
	fcomi	st(0), st(1)	; porównuje st(0) i st(1)
	ja		koniec
	fcomi	st(0), st(1)	; porównuje st(0) i st(1)
	je		jeden_pierwiastek
	fstp	st(0)			; usuniêcie 0 z wierzcho³ka stosu

	; x1 = (-b - sqrt(delta))/2a,      x2 = (-b + sqrt(delta))/2a
	fsqrt					; st(0) = sqrt(delta), st(1) = 4ac
	fld		dword ptr wsp_b ; wrzucam wspó³czynnik b na wierzcho³ek stosu koprocesora
	fchs					; zmiana znaku, st(0) = -b, st(1) = sqrt(delta), st(2) = 4ac
	fld		dword ptr wsp_a ; wrzucam wspó³czynnik a na wierzcho³ek stosu koprocesora
	; st(0) = a, st(1) = -b, st(2) = sqrt(delta), st(3) = 4ac
	fld		dword ptr dwa	; wrzucam na wierzcho³ek koprocesora liczbê 2
	fmulp					; wymna¿am st(0) = 2.0 i st(1) = a
	; st(0) = 2a, st(1) = -b, st(2) = sqrt(delta), st(3) = 4ac
	fst		st(3)			; kopiuje st(0) do st(3)
	; st(0) = 2a, st(1) = -b, st(2) = sqrt(delta), st(3) = 2a
	fstp	st(0)			; usuwam z wierzcho³ka koprocesora 2a
	fldz
	fadd	st(0), st(1)	; st(0) = -b, st(1) = -b, st(2) = sqrt(delta), st(3) = 2a
	fadd	st(0), st(2)	; st(0) = -b + sqrt(delta), st(1) = -b, st(2) = sqrt(delta), st(3) = 2a
	fdiv	st(0), st(3)	; st(0) = x2
	fstp	x2				; usuniêcie z wierzcho³ka stosu i przerzucenie wartoœci do x2
	; st(0) = -b, st(1) = sqrt(delta), st(2) = 2a
	fsub	st(0), st(1)	; st(0) = -b - sqrt(delta)
	fdiv	st(0), st(2)	; st(0) = x1
	fstp	x1				; usuniêcie z wierzcho³ka stosu i przerzucenie wartoœci do x1		
	jmp		koniec

jeden_pierwiastek:
	; x1 = x2 = (-b/2a)

koniec:
	fstp	st(0)
	fstp	st(0)
	fld		x2
	pop		ebp
	ret
_pierwiastki_rownania_kwadratowego_przyklad1 ENDP

_srednia_harm PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 4
	push	esi
	
	; wpisanie parametrów do rejestrów
	lea		eax, [ebp+12] ; int* n
	mov		ecx, [eax]		; n
	mov		esi, [ebp+8] ; float * tab
	mov		[ebp-4], dword ptr 1

	; 1/a[i] + 1/a[i+1]...
	fldz
ptl:
	fild	dword ptr [ebp-4]; zpuszowanie 1 na wierzcho³ek koprocesora
	fld		dword ptr [esi] ; zpuszowanie a[i] na wierzcho³ek koprocesora
	fdivp					; zapisanie st(1) = 1/a[i] i usuniêcie pop st(0)
	faddp					; sum += st(0), sum += 1/a[i] i pop
	add		esi, 4
	loop	ptl

	fild	dword ptr [eax] ; wrzucenie n na stos koprocesora
	fxch	st(1)	; zamiana miejsc -> st(0) = sum, st(1) = n
	fdivp

	pop		esi
	add		esp, 4
	pop		ebp
	ret
_srednia_harm ENDP
_nowy_exp PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 8
	push	edx
	push	ebx
	; pobranie parametru ze stosu
	fld		dword ptr [ebp+8] ; float x
	mov		ecx, 19
	mov		ebx, 1 ; kolejny mno¿nik
	mov		edx, 0

	push	ebx
	fild	dword ptr [esp] ; pierwszy element szeregu
	fild	dword ptr [esp] ; pierwszy element szeregu
	add		esp,4

	

	; st(0) = suma, st(1) = mianownik, st(2) = x^
pt:
	fld		st(2)	; x
	; x suma mianownik x^
	fld		st(2)
	; mianownik x suma mianownik x^
	push	ebx
	fimul	dword ptr [esp]
	add		esp, 4
	; a_mianownik x suma mianownik x^ 
	fst		st(3)
	; a_mianownik x suma mianownik x^ 
	fdivp	st(1), st(0) ; x/mianownik
	; x/mianownik suma mianownik x^ 
	faddp	st(1), st(0)
	; suma+x/mianownik mianownik x^ 
	fld		dword ptr [ebp+8]
	; x suma mianownik x^
	fmulp	st(3), st(0)
	; suma mianownik x^+1

	inc		ebx		; zwiêkszam kolejn¹ do przemno¿enia liczbê
	loop	pt
	
	pop		ebx
	pop		edx
	add		esp, 8
	pop		ebp
	ret
_nowy_exp ENDP


_dodaj_SSE PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi

	mov		esi, [ebp+8] ; adres pierwszej tablicy
	mov		edi, [ebp+12] ; adres drugiej tablicy
	mov		ebx, [ebp+16] ; adres tablicy wynikowej

	movups	xmm5, [esi]
	movups	xmm6, [edi]

	addps	xmm5, xmm6

	movups	[ebx], xmm5

	pop		edi
	pop		esi
	pop		ebx
	pop		ebp
	ret
_dodaj_SSE ENDP
_pierwiastek_SSE PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi

	mov		esi, [ebp+8]
	mov		ebx, [ebp+12]

	movups	xmm6, [esi]
	sqrtps	xmm5, xmm6

	movups	[ebx], xmm5

	pop		edi
	pop		esi
	pop		ebx
	pop		ebp
	ret
_pierwiastek_SSE ENDP
_odwrotnosc_SSE PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi

	mov		esi, [ebp+8]
	mov		ebx, [ebp+12]

	movups	xmm5, [esi]

	rcpps	xmm5, xmm5

	movups	[ebx], xmm5

	pop		ebx
	pop		esi
	pop		ebp
	ret
_odwrotnosc_SSE ENDP
_suma_char PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	edi
	push	ebx

	mov		esi, [ebp+8]
	mov		edi, [ebp+12]
	mov		ebx, [ebp+16]

	movups	xmm5, [esi]
	movups	xmm6, [edi]

	PADDSB	xmm5, xmm6

	movups	[ebx], xmm5

	pop		ebx
	pop		edi
	pop		esi
	pop		ebp
	ret
_suma_char ENDP
_int2float PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	edi
	push	ebx

	mov		esi, [ebp+8]
	mov		ebx, [ebp+12]

	cvtpi2ps	xmm5, qword ptr [esi]

	movups	[ebx], xmm5

	pop		ebx
	pop		edi
	pop		esi
	pop		ebp
	ret
_int2float ENDP
_pm_jeden PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	edi
	push	ebx

	mov		esi, [ebp+8]

	movups	xmm5, [esi]

	addsubps	xmm5, xmmword ptr tab

	movups	[esi], xmm5

	pop		ebx
	pop		edi
	pop		esi
	pop		ebp
	ret
_pm_jeden ENDP

_dodawanie_SSE PROC
	push	ebp
	mov		ebp, esp
	
	mov		eax, [ebp+8]
	
	movaps	xmm2, tabl_A
	movaps	xmm3, tabl_B
	movups	xmm4, tabl_C
	
	addps	xmm2, xmm3
	addps	xmm2, xmm4
	movups	[eax], xmm2
	
	pop		ebp
	ret
_dodawanie_SSE ENDP

_find_max_range PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	push	edx

	mov		ecx, [ebp+12] ; alpha
	mov		eax, [ebp+8] ; v

	fld		dword ptr [ebp+8]
	fmul	st(0), st(0);v^2
	fld		grav
	fdivp ; v^2 / g
	fild	dword ptr [ebp+12]
	mov		eax, 180
	push	eax
	fild	dword ptr [esp]
	add		esp, 4
	fdiv
	fldpi
	fmulp ; alpha(w rad)  v^2 / g
	fld		dwa
	fmul
	fsin
	fmulp

	pop		edx
	pop		ebx
	pop		ebp
	ret
_find_max_range ENDP
_mul_at_once PROC
	push	ebp
	mov		ebp, esp

	pmulld	xmm0, xmm1
	
	pop		ebp
	ret
_mul_at_once ENDP

END