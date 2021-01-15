kernel = ../Build/synos_kernel_${arch}_${version}.bin
ld_sh = link.ld
asm_src!= ls arch/${arch}/*.nasm
asm_obj!= ls arch/${arch}/*.nasm | sed -e "s/nasm/o/"
code_src!= find . -name "*.cpp"
code_obj!= find . -name "*.cpp" | sed -e "s/cpp/o/"

CFLAGS+= -I./../Klib/
LDFLAGS+= -L./../Klib/klib.o

all: kernel

kernel: ${asm_obj} ${code_obj} ${ld_sh}
	@ld -T ${ld_sh} ${code_obj} ${asm_obj} ${LDFLAGS} -o ${kernel} -O2 -nostdlib

${code_obj}: ${code_src}
	@echo "[4] Building CPP files"
	@${cc} -c ${.IMPSRC} ${CFLAGS} -o ${.TARGET}

${asm_obj}: ${asm_src}
	@echo "[3] Building ASM files"
	@nasm -f elf64 ${.ALLSRC} -o ${.TARGET}

.PHONY: all clean

clean:
	@echo "Cleaning kernel"
	@rm -rf ${asm_obj} ${code_obj}
