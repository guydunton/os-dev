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

To setup the environment run the command:

```bash
make setup
```

This will generate the docker image needed to build the system & create the build directory. This command can take several minutes to build to go make some tea.

Once the environment is built you can run the make commands above.

## Resources

- https://github.com/cfenollosa/os-tutorial
- https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
