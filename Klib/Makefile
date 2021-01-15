SRC!= find . -name "*.cpp"
OBJ!= find . -name "*.cpp" | sed -e "s/cpp/o/"

all: ${OBJ}

${OBJ}: ${SRC}
	@echo "[1] Building Klib"
	@${cc} -c ${.IMPSRC} ${CFLAGS} -o ${.TARGET} 

.PHONY: clean

clean:
	@echo "Cleaning Klib"
	@rm -rf ${OBJ}
