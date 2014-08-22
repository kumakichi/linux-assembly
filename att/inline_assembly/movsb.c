#include <stdio.h>

int main()
{
	int length = 25;
	char output[26];
	char input[26] = { "This is a test message.\n" };

	asm volatile (
        "pushl %%ecx\n\t"
        "pushl %%edi\n\t"
        "cld\n\t"
        "rep movsb\n\t"
        "movl $4,%%eax\n\t"
        "movl $1,%%ebx\n\t"
        "popl %%ecx\n\t"
        "popl %%edx\n\t"
        "int $0x80\n\t"
        ::"S" (input), "D"(output), "c"(length));

	return 0;
}
