# $^ = all dependencies
# $< = first dependency
# $@ = target file

.PHONY: clean run build

build: build/os-image.bin

build/kernal.o: src/kernal.c
	./toolchain i386-elf-gcc -ffreestanding -c $^  -o $@

build/kernal_entry.o: kernal_entry.asm
	nasm $^ -f elf -o $@

build/kernal.bin: build/kernal_entry.o build/kernal.o
	./toolchain i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

build/bootsect.bin: boot_sect.asm
	nasm $^ -f bin -o $@

build/os-image.bin: build/bootsect.bin build/kernal.bin
	cat $^  > $@

clean:
	rm build/*

run: build/os-image.bin
	qemu-system-i386 -fda $<
