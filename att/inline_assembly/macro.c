#include <stdio.h>

#define GREATER(a, b, result) ({\
            asm(                \
                "movl %[num1], %[ans]\n\t"      \
                "cmp %[num1], %[num2]\n\t"      \
                "cmova %[num2],%[ans]\n\t"      \
                :[ans] "=r"(result)             \
                :[num1] "r"(a), [num2] "r"(b));})

int main()
{
	int data1 = 10;
	int data2 = 20;
	int result;
	GREATER(data1, data2, result);
	printf("a = %d, b = %d result: %d\n", data1, data2, result);
	data1 = 30;
	GREATER(data1, data2, result);
	printf("a = %d, b = %d result: %d\n", data1, data2, result);
	return 0;
}
