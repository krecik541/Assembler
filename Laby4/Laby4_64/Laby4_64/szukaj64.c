#include<stdio.h>

extern __int64 szukaj_max(__int64 t[], __int64 n);
extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64 v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);
__int64 sum(unsigned int n, ...);
int main()
{
	/*__int64 t[] = {-15, 4000000, -345679, 88046592,-1, 2297645, 7867023, -19000444, -123456789098765, 31,456000000000000,444444444444444};

	__int64 wartosc = szukaj_max(t, 12);
	printf("Najwieksza wartosc to:  %I64d\n", wartosc);

	wartosc = suma_siedmiu_liczb(1, -1, 2, -2, 3, 3, -4);
	printf("Suma to:  %I64d\n", wartosc);*/

	__int64 wynik = sum(5, 1000000000000LL, 2LL, 3LL, 4LL, 5LL);  // 1000000000014
	printf("Suma to:  %I64d\n", wynik);
	wynik = sum(0);  // 0
	printf("Suma to:  %I64d\n", wynik); 
	wynik = sum(1, -3LL); // -3
	printf("Suma to:  %I64d\n", wynik); 
	wynik = sum(10, 1LL, 2LL, 3LL, 4LL, 5LL, 6LL, 7LL, 8LL, 9LL, 10LL); // 55
	printf("Suma to:  %I64d\n", wynik); 
	return 0;
}