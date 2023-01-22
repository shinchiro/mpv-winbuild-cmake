cmake_minimum_required(VERSION 3.19.0)
project(mpv-cross C)
include(ProcessorCount)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/download_externalproject.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/custom_steps.cmake)

cmake_policy(SET CMP0097 NEW)
cmake_policy(SET CMP0114 NEW)
if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

if(NOT CMAKE_GENERATOR STREQUAL "Ninja")
    message(WARNING "Generator “${CMAKE_GENERATOR}” is unsupported!\nTry Ninja if you encounter problems.")
endif()

set(TARGET_ARCH "x86_64-w64-mingw32" CACHE STRING "The target architecture for this toolchain.")
string(REGEX MATCH "^[^-]+" TARGET_CPU ${TARGET_ARCH})

execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpmachine OUTPUT_VARIABLE HOST_ARCH)
string(REGEX MATCH "^[^-]+" HOST_CPU ${HOST_ARCH})

if(TARGET_CPU MATCHES "x86_64")
    set(TARGET_CPU_FAMILY "x86_64")
    set(TARGET_BITS 64)
    set(GCC_ARCH "x86-64" CACHE STRING "GCC architecture levels for x86_64 target.")
    string(REGEX MATCH "-v3" x86_64_LEVEL ${GCC_ARCH})
else()
    set(TARGET_CPU_FAMILY "x86")
    set(TARGET_BITS 32)
endif()

processorcount(CPU_COUNT)
if(CPU_COUNT EQUAL 0)
    set(CPU_COUNT 1)
endif()

set(MAKEJOBS ${CPU_COUNT})
# set(MAKEJOBS 5) # uncomment this line to manually change no. of cpu
set(MAKEJOBS ${MAKEJOBS} CACHE STRING "Number of parallel processes to run for each package build")

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Default install path" FORCE )
endif()
set(MINGW_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/mingw)

option(ALWAYS_REMOVE_BUILDFILES "Always delete build files after successful compilation." OFF)
set(SINGLE_SOURCE_LOCATION "" CACHE STRING "Absolute path to download git & zip")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake @ONLY)
set(TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/meson_cross.txt.in ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt @ONLY)
set(MESON_CROSS ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/exec.in ${CMAKE_CURRENT_BINARY_DIR}/exec @ONLY)
set(EXEC ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(MAKE ${EXEC} make -j${MAKEJOBS})

string(TIMESTAMP BUILDDATE "%Y%m%d" UTC)

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/publish.in)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/publish.in ${CMAKE_CURRENT_BINARY_DIR}/publish)
endif()

add_subdirectory(toolchain)
add_subdirectory(packages)
