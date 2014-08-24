#include <stdio.h>

char *cpuidfunc(void);

int main()
{
	char *spValue;
	spValue = cpuidfunc();
	printf("The CPUID is: '%s'\n", spValue);
	return 0;
}
