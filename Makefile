files := boot_sect.asm src/*.asm src/*.c
.PHONY: clean run build

build: build/os-image.bin

build/kernal.o:
	./toolchain i386-elf-gcc -ffreestanding -c ./src/kernal.c  -o ./build/kernal.o

build/kernal_entry.o:
	nasm kernal_entry.asm -f elf -o build/kernal_entry.o

build/kernal.bin: build/kernal_entry.o build/kernal.o
	./toolchain i386-elf-ld -o ./build/kernal.bin -Ttext 0x1000 ./build/kernal_entry.o ./build/kernal.o --oformat binary

build/bootsect.bin:
	nasm boot_sect.asm -f bin -o build/bootsect.bin

build/os-image.bin: build/kernal.bin build/bootsect.bin
	cat build/bootsect.bin build/kernal.bin  > build/os-image.bin

clean:
	rm build/*

run: build/os-image.bin
	qemu-system-i386 -fda ./build/os-image.bin
