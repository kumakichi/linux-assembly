void main(void)
{
	asm_show_arg();
}

/* nasm -f elf32 -o show_arg.o show_arg.s  */
/* gcc -o demo demo.c show_arg.o  */
