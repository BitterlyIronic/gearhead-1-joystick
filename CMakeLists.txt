set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake_modules")

enable_language(Pascal)
cmake_minimum_required(VERSION 3.24)
project(gharena)
include(GNUInstallDirs)

find_package(SDL REQUIRED)
find_package(SDL_ttf REQUIRED)
find_package(SDL_image REQUIRED)

add_compile_options(-dSDLMODE -dJOYSTICK_SUPPORT -O4 -OoLOOPUNROLL -OoAUTOINLINE -B)
add_executable(gharena gharena.pas)

file(GLOB INSTALLED_FILES GameData Design Image Series)
file(COPY ${INSTALLED_FILES} DESTINATION .)

install(TARGETS gharena DESTINATION ${CMAKE_INSTALL_BINDIR})

install(DIRECTORY ${INSTALLED_FILES} DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/gharena)
