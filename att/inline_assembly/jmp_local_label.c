#include <stdio.h>

int main(void)
{
	int a = 10;
	int b = 20;
	int result;

    /* The inline assembly labels are encoded into the final assembled code,this means that if you have another asm section in your C code, you cannot use the same labels again, or an error message will result due to duplicate use of labels. In addition, if you try to incorporate labels that use C keywords, such as function names or global variables, you will also generate errors. */

    /* asm("cmp %1, %2\n\t" */
    /*     "jge greater\n\t" */
    /*     "movl %1, %0\n\t" */
    /*     "jmp end\n" */
    /*     "greater:\n\t" */
    /*     "movl %2, %0\n" */
    /*     "end:" */
    /*     :"=r"(result) */
    /*     :"r"(a), "r"(b)); */

/* The JGE and JMP instructions use the f modifier to indicate the label is forward from the jump instruction. To move backward, you must use the b modifier. */

    asm("cmp %1, %2\n\t"
        "jge 0f\n\t"
        "movl %1, %0\n\t"
        "jmp 1f\n"
        "0:\n\t"
        "movl %2, %0\n"
        "1:"
        :"=r"(result)
        :"r"(a), "r"(b));

	printf("The larger value is %d\n", result);
	return 0;
}
