; program przyk³adowy (wersja 32-bitowa)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
public _main
.data
tekst db 10, 'Nazywam si', 169, ' Maciej Szymczak ' , 10
db 'M', 162, 'j pierwszy 32-bitowy program '
db 'asemblerowy dziala ju', 190, ' poprawnie!', 10
koniec db ? ; czy to na pewno jes poprawne????????
.code
_main PROC
mov ecx, OFFSET koniec - OFFSET tekst ; liczba znaków wyœwietlanego tekstu
; wywo³anie funkcji ”write” z biblioteki jêzyka C
push ecx ; liczba znaków wyœwietlanego tekstu
push dword PTR OFFSET tekst ; po³o¿enie obszaru
; ze znakami
push dword PTR 1 ; uchwyt urz¹dzenia wyjœciowego
call __write ; wyœwietlenie znaków
; (dwa znaki podkreœlenia _ )
add esp, 12 ; usuniêcie parametrów ze stosu
; zakoñczenie wykonywania programu
push dword PTR 0 ; kod powrotu programu
call _ExitProcess@4
_main ENDP
END