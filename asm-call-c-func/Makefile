.PHONY: all

all: demo

demo: func.c demo.s
	nasm -f "elf32" demo.s -o demo.o
	gcc -s -c func.c
	ld -dynamic-linker /lib/ld-linux.so.2 -o $@ demo.o func.o --entry=_main -lc

clean:
	@-rm *.o *~ normal tiny demo
