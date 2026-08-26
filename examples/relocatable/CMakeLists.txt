cmake_minimum_required(VERSION 3.20)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/toolchain.cmake)
project(tasking_c166_relocatable_example LANGUAGES C)

add_executable(payload payload.c)
target_link_options(payload PUBLIC -nolib -cl)
