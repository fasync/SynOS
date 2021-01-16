# Source Files
set(KERNEL_ALGO_CXX_SRC
  algo/crc32.cpp
  )

set(KERNEL_CORE_CXX_SRC
  core/main.cpp
  core/error/cxa_virtual.cpp
  )

set(KERNEL_ARCH_ASM_SRC arch/amd64/bootloader.nasm)

# Settings
set(CMAKE_EXE_LINKER_FLAGS "-T link.ld")
set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

add_executable (${Project_Title}
  ${KERNEL_ARCH_ASM_SRC}
  ${KERNEL_CORE_CXX_SRC}
  ${KERNEL_ALGO_CXX_SRC}
  )

target_compile_options(${Project_Title} PUBLIC -nostdlib -ffreestanding -O2 -Werror -Wall -Wextra -fno-exceptions -fno-rtti -fPIC)
target_include_directories(${Project_Title} PUBLIC ../Klib/)
target_link_libraries(${Project_Title} klib)
