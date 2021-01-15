cc = clang++
arch = amd64
version = 0_0_1
target = ${arch}-unknown-symos
kernel = Build/synos_kernel_${arch}_${version}.bin
iso = Build/synos_run_${arch}_${version}.iso

CFLAGS+= -ffreestanding
CFLAGS+= -O2
CFLAGS+= -Werror
CFLAGS+= -Wall
CFLAGS+= -Wextra
CFLAGS+= -fno-exceptions
CFLAGS+= -fno-rtti
CFLAGS+= -fPIC

all: prepare iso
	@echo "[!] Building SynOS finished."

prepare:
	@chmod u+x ./env
	@./env

iso: kernel
	@echo "[5] Building ISO File"
	@mkisofs -o ${iso} ${kernel} > /dev/null 2>&1


kernel: lib
	@mkdir -p Build/arch/${arch}
	@echo "[2] Building Kernel"
	@make cc=${cc} arch=${arch} CFLAGS="${CFLAGS}" version=${version} -C ./kern

lib:
	@echo "[0] Building CXX+C+KLib"
	@make cc=${cc} arch=${arch} CFLAGS="${CFLAGS}" version=${version} -C ./Clib
	@make cc=${cc} arch=${arch} CFLAGS="${CFLAGS}" version=${version} -C ./CXXlib
	@make cc=${cc} arch=${arch} CFLAGS="${CFLAGS}" version=${version} -C ./Klib

.PHONY: all clean run iso kernel

run: iso
	@echo "Running SynOS"
	@qemu-system-x86_64 -cdrom ${iso} -vga std -s -serial file:serial.log

clean:
	@make arch=${arch} version=${version} clean -C ./kern
	@make arch=${arch} version=${version} clean -C ./Clib
	@make arch=${arch} version=${version} clean -C ./CXXlib
	@make arch=${arch} version=${version} clean -C ./Klib
	@echo "Cleaning root"
	@rm -rf Build
