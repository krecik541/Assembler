#include<stdio.h>
#include<xmmintrin.h>

float pierwiastki_rownania_kwadratowego_przyklad1();
float srednia_harm(float* tablica, unsigned int n);
float nowy_exp(float x);
void dodaj_SSE(float*, float*, float*);
void pierwiastek_SSE(float*, float*);
void odwrotnosc_SSE(float*, float*);
void suma_char(char* A, char* B, char* wyn);
void int2float(int* calkowite, float* zmienno_przec);
void pm_jeden(float* tabl);
void dodawanie_SSE(float* a);


float find_max_range(float v, int alpha);
__m128 mul_at_once(__m128 one, __m128 two);

int main()
{//printf("Wynik pierwiastki_rownania_kwadratowego_przyklad1:\t%f\n", pierwiastki_rownania_kwadratowego_przyklad1());

	/*unsigned int n;
	scanf_s("%d", &n);
	float* tab = (float*)malloc(n * sizeof(float));
	for (int i = 0; i < n; i++)
	{
		scanf_s("%f", &tab[i]);
	}
	printf("Wynik srednia_harm:\t%f\n", srednia_harm(tab, n));
	free(tab);*/

	/*float x;
	scanf_s("%f", &x);
	printf("Wynik:\t%f\n", nowy_exp(x));*/

	/*float p[4] = {1.0, 1.5, 2.0, 2.5};
	float q[4] = { 0.25, -0.5, 1.0, -1.75 };
	float r[4];

	dodaj_SSE(p, q, r);
	printf("%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", q[0], q[1], q[2], q[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);

	printf("\n\nObliczanie pierwiastka");
	pierwiastek_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);

	printf("\n\nObliczanie odwrotnoœci - ze wzglêdu na stosowanie");
	printf("\n12-bitowej mantysy obliczenia s¹ ma³o dok³adne");
	odwrotnosc_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);*/

	/*char liczby_A[16] = {-128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127};
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	//char liczby_B[16] = { 3, 3, 3, 3, 3, 3, 3, 3, -3, -3, -3, -3, -3, -3, -3, -3 };
	char wynik[16];
	suma_char(liczby_A, liczby_B, wynik);
	printf("\n\nSuma liczb uwzglêdniaj¹c nasycenie\n");
	printf("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n", liczby_A[0], liczby_A[1], liczby_A[2], liczby_A[3], liczby_A[5], liczby_A[6], liczby_A[7], liczby_A[8], liczby_A[9], liczby_A[10], liczby_A[11], liczby_A[12], liczby_A[13], liczby_A[14], liczby_A[15]);
	printf("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n", liczby_B[0], liczby_B[1], liczby_B[2], liczby_B[3], liczby_B[5], liczby_B[6], liczby_B[7], liczby_B[8], liczby_B[9], liczby_B[10], liczby_B[11], liczby_B[12], liczby_B[13], liczby_B[14], liczby_B[15]);
	printf("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n", wynik[0], wynik[1], wynik[2], wynik[3], wynik[5], wynik[6], wynik[7], wynik[8], wynik[9], wynik[10], wynik[11], wynik[12], wynik[13], wynik[14], wynik[15]);
*/

/*int a[2] = {-17, 24};
float r[4];
int2float(a, r);
printf("Konwersja = %f %f\n", r[0], r[1]);*/

/*float tablica[4] = {27.5, 143.57, 2100.0, -3.51};
printf("\n%f %f %f %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);
pm_jeden(tablica);
printf("\n%f %f %f %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);*/

/*float wyniki[4];
dodawanie_SSE(wyniki);
printf("\nWyniki = %f %f %f %f\n",
	wyniki[0], wyniki[1], wyniki[2], wyniki[3]);
*/

/*float wynik;
wynik = objetosc_stozka(6, 2, 5.3); //288,60765
printf("Wynik: %f\n", wynik);
wynik = objetosc_stozka(7, 3, 4.2); //347,46015
printf("Wynik: %f\n", wynik);
wynik = objetosc_stozka(8, 4, 6.1); //715,44537
printf("Wynik: %f\n", wynik);*/

/*int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
int wynik[8];
szybki_max(val1, val2, wynik, 8);

printf("%d %d %d %d %d %d %d %d \n", wynik[0], wynik[1], wynik[2], wynik[4], wynik[3], wynik[5], wynik[6], wynik[7]);


float wyn = find_max_range(5, 45);
printf("\nWynik: %f", wyn);*/

/*__m128 jeden, dwa;
jeden.m128_i32[0] = 4;
jeden.m128_i32[1] = 5;
jeden.m128_i32[2] = 6;
jeden.m128_i32[3] = 7;

dwa.m128_i32[0] = 3;
dwa.m128_i32[1] = 3;
dwa.m128_i32[2] = 3;
dwa.m128_i32[3] = 3;

__m128 wynik = mul_at_once(jeden, dwa);

for (int i = 0; i < 4; i++)
{
	printf("%d\n", wynik.m128_i32[i]);
}*/
	float wyn = find_max_range(15.2, 45);
	printf("\nWynik: %f", wyn);
	wyn = find_max_range(20, 30);
	printf("\nWynik: %f", wyn);
	wyn = find_max_range(20, 80);
	printf("\nWynik: %f", wyn);

	__m128 jeden, dwa;
	jeden.m128_i32[0] = 4;
	jeden.m128_i32[1] = 5;
	jeden.m128_i32[2] = 6;
	jeden.m128_i32[3] = 7;

	dwa.m128_i32[0] = 3;
	dwa.m128_i32[1] = 3;
	dwa.m128_i32[2] = 3;
	dwa.m128_i32[3] = 3;

	__m128 wynik = mul_at_once(jeden, dwa);

	for (int i = 0; i < 4; i++)
	{
		printf("%d\n", wynik.m128_i32[i]);
	}


	return 0;
}
