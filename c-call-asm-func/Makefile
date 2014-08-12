.PHONY: all

all: normal tiny demo

demo: func.s demo1.c
	nasm -f "elf32" func.s -o func.o
	gcc -s -o $@ demo1.c func.o

normal: func.s demo1.c
	nasm -f "elf32" func.s -o func.o
	gcc -s -c demo1.c
	ld -dynamic-linker /lib/ld-linux.so.2 -o $@ demo1.o func.o --entry=main -lc

tiny: func.s demo2.c
	nasm -f "elf32" func.s -o func.o
	gcc -s -c demo2.c
	ld -s -o $@ demo2.o func.o --entry=main

clean:
	@-rm *.o *~ normal tiny demo
