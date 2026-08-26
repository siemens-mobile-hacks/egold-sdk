cmake_minimum_required(VERSION 3.20)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/toolchain.cmake)
project(example_patch LANGUAGES C ASM)

add_executable(C60v27 src/patch.c)
define_patch(C60v27 C60 27)

add_executable(M55v91 src/patch.c)
define_patch(M55v91 M55 91)
