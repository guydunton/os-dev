# $^ = all dependencies
# $< = first dependency
# $@ = target file

.PHONY: clean run build

# Get all the c files in kernal & drivers
C_SOURCES = $(wildcard kernal/*.c drivers/*.c)
HEADERS = $(wildcard kernal/*.h drivers/*.h)

# Replace all the .c's in c_sources with .o's
OBJ := $(C_SOURCES:.c=.o)
OBJ2 := $(OBJ:kernal/%=build/%)
OBJ3 := $(OBJ2:drivers/%=build/%)

build: build/os-image.bin

build/os-image.bin: build/bootsect.bin build/kernal.bin
	cat $^  > $@

build/kernal.bin: build/kernal_entry.o ${OBJ3}
	./toolchain i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

build/%.o: kernal/%.c ${HEADERS}
	./toolchain i386-elf-gcc -ffreestanding -c $<  -o $@

build/%.o: drivers/%.c ${HEADERS}
	./toolchain i386-elf-gcc -ffreestanding -c $<  -o $@

build/%.o: boot/%.asm
	nasm $< -f elf -o $@

build/%.bin: boot/%.asm
	nasm $^ -f bin -o $@

clean:
	rm build/*

run: build/os-image.bin
	qemu-system-i386 -fda $<
