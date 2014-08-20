.PHONY:all

all:hex3

hex3:hex3.s textlib.s
	nasm -f elf -o hex3.o hex3.s
	nasm -f elf -o textlib.o textlib.s
	ld -o hex3 hex3.o textlib.o

clean:
	@-rm *~ *.o hex3
