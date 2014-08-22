/* alttest.c – An example of using alternative placeholders */
#include <stdio.h>
int main()
{
	int data1 = 10;
	int data2 = 20;

    asm("imull %[from], %[to]"
        :[to] "=r"(data2)
        :[from] "r"(data1), "0"(data2));

	printf("The result is %d\n", data2);
	return 0;
}

/* The alternative name is defined within the sections in which the input and output values are declared,the format is as follows: */
/* %[name]"constraint"(variable) */
