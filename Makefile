all: boot

boot:
	nasm -f bin boot.asm -o boot.bin

run: all
	qemu-system-x86_64 boot.bin