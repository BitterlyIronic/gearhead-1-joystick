set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake_modules")

enable_language(Pascal)
cmake_minimum_required(VERSION 3.24)
project(gharena)

find_package(SDL REQUIRED)

add_compile_options(-dSDLMODE -dJOYSTICK_SUPPORT -O4 -OoLOOPUNROLL -OoAUTOINLINE -B)
add_executable(gharea gharena.pas)
