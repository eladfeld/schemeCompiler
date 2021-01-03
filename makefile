all: foo


foo: foo.o
	gcc -static -m64 -o foo foo.o

foo.o: foo.s
	nasm -f elf64 -o foo.o foo.s