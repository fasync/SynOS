cmake_minimum_required (VERSION 3.8)

set (Project_Title "SynOS")
set (arch "amd64")
set (version "0_0_1")

enable_language(ASM)

project (${Project_Title} LANGUAGES ASM CXX)
set(CMAKE_CXX_STANDARD 17)


add_subdirectory(Klib)
#add_subdirectory(Clib)
#add_subdirectory(CXXlib)
add_subdirectory(kernel)
