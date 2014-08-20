.PHONY: all

all: demo demo_gcc

demo: func.c demo.s
	nasm -f "elf32" demo.s -o demo.o
	gcc -s -c func.c
	ld -dynamic-linker /lib/ld-linux.so.2 -o $@ demo.o func.o --entry=_main -lc

demo_gcc: func.c demo_gcc.s
	nasm -f "elf32" demo_gcc.s -o demo_gcc.o
	gcc -s -c func.c
	gcc -o $@ func.o demo_gcc.o

clean:
	@-rm *.o *~ normal tiny demo demo_gcc
