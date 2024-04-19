#include<stdio.h>
#include<windows.h>

int szukaj4_max(int a, int b, int c, int d);
void plus_jeden(int* a);
int liczba_przeciwna(int a);
void odejmij_jeden(int** a);
void bubble_sort(int t[], int n);
int __stdcall najwieksza_liczba_STDCALL(int a, int b, int c);
int dot_product(int tab1[], int tab2[], int n);
int isPalindrome(wchar_t* strng, unsigned int liczba_znakow);
int dzielenie(int* dzielna, int** dzielnik);
unsigned int check_system_dir(char* directory);
unsigned int fibonacci(unsigned char k);
int swap(int tab[], unsigned int n, int pos1, int pos2);


typedef struct _czas {
	unsigned char godzina;
	unsigned char minuty;
} czas;
void daj_czas(czas* cz);


int main()
{
	// przyk³ad
	/*int a, b, c, d, wynik;
	scanf_s("%d %d %d %d", &a, &b, &c, &d, 32);
	wynik = szukaj4_max(a, b, c, d);
	printf("Najwieksza liczba to %d", wynik);*/
	
	// zadanie 4.1
	/*int m = -5;
	plus_jeden(&m);
	printf("Wartosc liczby to %d", m);*/

	// zadanie 4.2
	/*int a = 5;
	a = liczba_przeciwna(a);
	printf("Wartosc liczby to %d", a);*/

	/*int k;
	int* wsk = &k;

	printf("Prosze podac liczbe: ");
	scanf_s("%d", &k);

	odejmij_jeden(&wsk);
	printf("Wartosc liczby to %d", k);*/

	/*int t[] = {1, 4, -4, 5, 13, 0, -2};

	bubble_sort(t, 7);

	for (int i = 0; i < 7; i++)
		printf(" %d ", t[i]);*/

	/*printf("Najwiêksza liczba to: %d\n", najwieksza_liczba_STDCALL(1, 4, -1));
	printf("Najwiêksza liczba to: %d\n", najwieksza_liczba_STDCALL(-1, 1, 4));
	printf("Najwiêksza liczba to: %d\n", najwieksza_liczba_STDCALL(4, -1, 1));*/

	/*int tab1[] = {1,2,3, 4, 5};
	int tab2[] = { 1,2,3, 4, 5 };
	int wynik = dot_product(tab1, tab2, 5);
	printf("Iloczyn skalarny tych wektorow to: %d", wynik);*/

	/*int wynik = isPalindrome(u"kajak", 5);
	printf("Wynik: %d\n", wynik);
	wynik = isPalindrome(u"korek", 5);
	printf("Wynik: %d\n", wynik);
	wynik = isPalindrome(u"alla", 4);
	printf("Wynik: %d\n", wynik);
	wynik = isPalindrome(u"acla", 4);
	printf("Wynik: %d\n", wynik);*/

	/*int a = 5;
	int b = -2;
	int* wsk = &b;
	int wynik = dzielenie(&a, &wsk);

	printf("Wynik: %d\n", wynik);
	a = -6;
	wynik = dzielenie(&a, &wsk);

	printf("Wynik: %d\n", wynik);*/

	/*GetSystemDirectory("C:\Users\Maciej\Desktop\3_sem\AKO\Laby4\Laby4", 46);//C:\windows\system32
	int wynik = check_system_dir("C:\\Windows\\system32hdzhdhr");
	printf("Wynik: %d\n", wynik);
	wynik = check_system_dir("C:\\Windows\\syste\\12");
	printf("Wynik: %d\n", wynik);*/

	
	/*int wynik = fibonacci(5);
	printf("Wynik dla i = %d to %d\n", 5, wynik);

	for (int i = 0; i<10; i++)
	{
		int wynik = fibonacci(i);
		printf("Wynik dla i = %d to %d\n", i, wynik);
	}*/

	/*int tab[] = {1, 2, 3, 4, 5};
	int wynik = swap(tab, 5, 1, 4); // tab = [1, 5, 3, 4, 2] , returned 1
	printf("Wynik %d\n", wynik);
	for (int i = 0; i < 5; i++)
	{
		printf("t[%d] = %d\n", i, tab[i]);
	}
	
	tab[0] = 1;
	tab[1] = 2;
	tab[2] = 3;
	tab[3] = 4;
	tab[4] = 5;
	wynik = swap(tab, 5, 1, 5); // tab = [1, 2, 3, 4, 5] , returned 0
	printf("Wynik %d\n", wynik);
	for (int i = 0; i < 5; i++)
	{
		printf("t[%d] = %d\n", i, tab[i]);
	}*/

	czas cz;
	daj_czas(&cz);
	printf("Jest godzina: %02d:%02d\n", cz.godzina, cz.minuty);

	return  0;
}