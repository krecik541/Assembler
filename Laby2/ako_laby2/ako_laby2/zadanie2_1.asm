; program przyk�adowy (wersja 32-bitowa)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
public _main
.data
tekst db 10, 'Nazywam si', 169, ' Maciej Szymczak ' , 10
db 'M', 162, 'j pierwszy 32-bitowy program '
db 'asemblerowy dziala ju', 190, ' poprawnie!', 10
koniec db ? ; czy to na pewno jes poprawne????????
.code
_main PROC
mov ecx, OFFSET koniec - OFFSET tekst ; liczba znak�w wy�wietlanego tekstu
; wywo�anie funkcji �write� z biblioteki j�zyka C
push ecx ; liczba znak�w wy�wietlanego tekstu
push dword PTR OFFSET tekst ; po�o�enie obszaru
; ze znakami
push dword PTR 1 ; uchwyt urz�dzenia wyj�ciowego
call __write ; wy�wietlenie znak�w
; (dwa znaki podkre�lenia _ )
add esp, 12 ; usuni�cie parametr�w ze stosu
; zako�czenie wykonywania programu
push dword PTR 0 ; kod powrotu programu
call _ExitProcess@4
_main ENDP
END