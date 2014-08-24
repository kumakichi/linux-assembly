#include <stdio.h>
int main()
{
	int i = 2;
	int j = asm_square(i);
	printf("The square of %d is %d\n", i, j);
	j = asm_square(10);
	printf("The square of 10 is %d\n", j);
	return 0;
}
