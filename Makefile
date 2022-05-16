# .PHONY: clean run

build/boot_sect.bin:
	mkdir -p build && \
	nasm boot_sect.asm -f bin -o build/boot_sect.bin

clean:
	rm -f build/boot_sect.bin

run: build/boot_sect.bin
	qemu-system-x86_64 build/boot_sect.bin
