#include <stdio.h>

int main(int argc, char *argv[])
{
	int data = 10;
	int result = 20;

    /* gcc will refuse compiling the following code, the proper  */
    /* use of the changed register list is to notify the compiler  */
    /* if your inline assembly code uses any additional registers  */
    /* that were not initially declared as input or output values */


    /* asm volatile ("addl %[f], %[t]" */
    /*     :[t] "=d"(result) */
    /*     :[f] "c"(data), "0"(result) */
    /*     :"%ecx", "%edx"); */

    asm volatile ("addl %[f], %[t]"
        :[t] "=d"(result)
        :[f] "c"(data), "0"(result));

	printf("The result is %d\n", result);
	return 0;
}
