FROM gcc

WORKDIR /build

RUN apt update -y
RUN apt install -y \
    build-essential bison flex libgmp3-dev \
    libmpc-dev libmpfr-dev texinfo libisl-dev curl

ENV PREFIX="/usr/local/i386elfgcc"
ENV TARGET=i386-elf
ENV PATH="$PREFIX/bin:$PATH"

RUN curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.gz && \
    tar xf binutils-2.38.tar.gz && \
    mkdir binutils-build && cd binutils-build && \
    ../binutils-2.38/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX && \
    make all install
RUN curl -O https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.gz && \
    tar xf gcc-12.1.0.tar.gz && \
    mkdir gcc-build && cd gcc-build && \
    ../gcc-12.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-languages=c --without-header && \
    make all-gcc && make all-target-libgcc && \
    make install-gcc && make install-target-libgcc

WORKDIR /work

# At this point should have a working toolchain
