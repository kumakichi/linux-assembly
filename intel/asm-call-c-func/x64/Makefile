.PHONY: all

all: demo

demo: func.c demo.s
	nasm -f "elf64" demo.s -gstabs -o demo.o
	gcc -s -c func.c
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ demo.o func.o --entry=_main -lc

clean:
	@-rm *.o *~ normal tiny demo
