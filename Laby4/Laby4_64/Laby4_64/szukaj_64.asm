public szukaj_max
public suma_siedmiu_liczb
public sum

.code
szukaj_max PROC
	; w rcx jest t[0], a w rdx n
	push	rsi 

	mov		rsi, rcx ; adres pocz¹tku tablicy
	lea		rdx, [rsi + 8 * rdx] ; adres koñca tablicy
	mov		rax, [rsi] ; pierwsza liczba w tablicy jest tymczasowo najwiêksz¹
	add		rsi, 8 ; rsi wskazuje na element t[1]
ptl:	cmp		rax, [rsi] ; max <= t[rsi]
		jng		dalej
		mov		rax, [rsi] ; max = t[rsi]
dalej:	add		rsi, 8 
		cmp		rsi, rdx
		jne		ptl
	
	pop		rsi
	ret
szukaj_max ENDP

suma_siedmiu_liczb PROC
	; rcx, rdx, r8, r9
	; rax
	push	rbp
	mov		rbp, rsp
	
	mov		rax, 0
	
	add		rax, rcx
	add		rax, rdx
	add		rax, r8
	add		rax, r9

	add		rax, [rbp+48]
	add		rax, [rbp+56]
	add		rax, [rbp+64]

	pop		rbp
	ret
suma_siedmiu_liczb ENDP

sum	PROC
	push	rbp
	mov		rbp, rsp
	push	rsi
	
	; n w rcx
	cmp		rcx, 0
	jnz		moze_1
	mov		eax, 0
	jmp		koniec

moze_1:
	cmp		rcx, 1
	jnz		moze_2
	mov		rax, rdx
	jmp		koniec

moze_2:
	cmp		rcx, 2
	jnz		moze_3
	mov		rax, rdx
	add		rax, r8
	jmp		koniec

moze_3:
	cmp		rcx, 3
	jnz		ponad_4
	mov		rax, rdx
	add		rax, r8
	add		rax, r9
	jmp		koniec

ponad_4:
	; œci¹gniêcie parametrów ze stosu
	lea		rsi, [rbp+48]
	mov		rax, rdx
	add		rax, r8
	add		rax, r9

ptl1:	add		rax, [rsi]
		add		rsi, 8
		dec		rcx
		cmp		rcx, 3
		jnz		ptl1


koniec:
	pop		rsi
	pop		rbp
	ret
sum	ENDP
END