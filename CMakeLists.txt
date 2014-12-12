cmake_minimum_required(VERSION 2.8.11)
project(mpv-cross C)
include(ExternalProject)
include(ProcessorCount)

if(NOT ${CMAKE_GENERATOR} MATCHES "Ninja")
    message(WARNING "Generator “${CMAKE_GENERATOR}” is unsupported!\nTry Ninja if you encounter problems.")
endif()

set(TARGET_ARCH "x86_64-w64-mingw32" CACHE STRING "The target architecture for this toolchain.")
string(REGEX MATCH "^[^-]+" TARGET_CPU ${TARGET_ARCH})

execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpmachine OUTPUT_VARIABLE HOST_ARCH)
string(REGEX MATCH "^[^-]+" HOST_CPU ${HOST_ARCH})

if(${TARGET_CPU} MATCHES "x86_64")
    set(TARGET_BITS 64)
else()
    set(TARGET_BITS 32)
endif()

processorcount(MAKEJOBS)
if(MAKEJOBS EQUAL 0)
    set(MAKEJOBS 1)
endif()
set(MAKEJOBS ${MAKEJOBS} CACHE STRING "Number of parallel processes to run for each package build")

set(MINGW_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/mingw)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)
set(TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/exec.in ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(EXEC ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(MAKE ${EXEC} make -j${MAKEJOBS})
set(DEBPATCH ${CMAKE_CURRENT_SOURCE_DIR}/debpatch)

string(TIMESTAMP BUILDDATE "%Y%m%d")

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/publish.in)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/publish.in ${CMAKE_CURRENT_BINARY_DIR}/publish)
endif()

add_subdirectory(toolchain)
add_subdirectory(packages)
