/* 1. asm ("assembly code" : output locations : input operands : changed registers); */

/* 2. input and output values can be read from either registers or memory locations as this format : "constraint"(variable) */

/* constraint      Description */
/*     a       Use the %eax, %ax, or %al registers. */
/*     b       Use the %ebx, %bx, or %bl registers. */
/*     c       Use the %ecx, %cx, or %cl registers. */
/*     d       Use the %edx, %dx, or $dl registers. */
/*     S       Use the %esi or %si registers. */
/*     D       Use the %edi or %di registers. */
/*     r       Use any available general-purpose register. */
/*     q       Use either the %eax, %ebx, %ecx, or %edx register. */
/*     A       Use the %eax and the %edx registers for a 64-bit value. */
/*     f       Use a floating-point register. */
/*     t       Use the first (top) floating-point register. */
/*     u       Use the second floating-point register. */
/*     m       Use the variable’s memory location. */
/*     o       Use an offset memory location. */
/*     V       Use only a direct memory location. */
/*     i       Use an immediate integer value. */
/*     n       Use an immediate integer value with a known value. */
/*     g       Use any register or memory location available. */

/* 3. output values include a constraint modifier */

/* Output_Modifier     Description */
/*     +           The operand can be both read from and written to. */
/*     =           The operand can only be written to. */
/*     %           The operand can be switched with the next operand if necessary. */
/*     &           The operand can be deleted and reused before the inline functions complete. */

/* asm ("assembly code" : "=a"(result) : "d"(data1), "c"(data2)); */

#include <stdio.h>
int main()
{
	int data1 = 10;
	int data2 = 20;
	int result;

    asm("imull %%edx, %%ecx\n\t"
        "movl %%ecx, %%eax"  /* asm code */
        :"=a"(result)        /* output */
        :"d"(data1), "c"(data2));  /* input */

	printf("The result is %d\n", result);
	return 0;
}
