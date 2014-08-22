/* asm ("assembly code" */
/* : "=r"(result) */
/* : "r"(data1), "r"(data2)); */

/* will produce the following placeholders: */
/* ❑ %0 will represent the register containing the result variable value. */
/* ❑ %1 will represent the register containing the data1 variable value. */
/* ❑ %2 will represent the register containing the data2 variable value. */
#include <stdio.h>
int main()
{
	int data1 = 10;
	int data2 = 20;

    /* normal way */

    /* asm("imull %1, %2\n\t" */
    /*     "movl %2, %0" */
    /*     :"=r"(result) */
    /*     :"r"(data1), "r"(data2)); */

    /* gentle way */
    asm("imull %1, %0\n\t"
        :"=r"(data2)
        :"r"(data1), "0"(data2));  /* The 0 tag signals the compiler to use the first named register for the output value data2 */


	printf("The result is %d\n", data2);
	return 0;
}
