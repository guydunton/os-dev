# Bootloader

This project builds a bootloader. I'm not sure why yet.

## Prerequisites

* nasm - The assembler that will be used to build the code
* qemu - The CPU emulator
* make - The build tool

## How to build it

```bash
make
```

## To run

```bash
make run
```

## Running the toolchain in docker

Because I am developing on a mac I don't have access to the GNU toolchain so I am using docker.

For example, to run GCC I'm running the following command:

```bash
docker run -v $(pwd):/work -w /work gcc ld -o ./build/basic.bin -Ttext 0x0 --oformat binary ./basic.o
```

Using the toolchain bash script makes this easier. e.g:

```bash
./toolchain ld -o ./build/basic.bin -Ttext 0x0 --oformat binary ./basic.o
```

## Building the C code

The C code must be:

1. Compiled
2. Linked
3. Disassembled to be viewed

```bash
# Compile the code
gcc -ffreestanding -c src/basic.c -o ./build/basic.o

# Link the binary
ld -o ./build/basic.bin -Ttext 0x0 --oformat binary ./build/basic.o

# Disassemble
ndisasm -b 32 ./build/basic.bin > basic.dis
```

## Resources

- https://github.com/cfenollosa/os-tutorial
- https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
