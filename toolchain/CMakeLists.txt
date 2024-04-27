set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
include(${PROJECT_SOURCE_DIR}/cmake/toolchain_check.cmake)
list(APPEND ep
    gcc-binutils
    ${llvm_wrapper}
    ${gcc_wrapper}
    mingw-w64
    mingw-w64-headers
    cppwinrt
    gcc
    mingw-w64-crt
    gendef
    widl
    rustup
    llvm
    llvm-compiler-rt-builtin
    llvm-libcxx
    llvm-compiler-rt
    llvm-openmp
    winpthreads
    llvm-clang
)
foreach(package IN LISTS ep)
    if(NOT ${SINGLE_SOURCE_LOCATION} STREQUAL "")
        set(SOURCE_LOCATION "${SINGLE_SOURCE_LOCATION}/${package}")
    endif()
    if(package MATCHES "llvm")
        include(${CMAKE_CURRENT_SOURCE_DIR}/llvm/${package}.cmake)
    elseif(package MATCHES "gcc")
        include(${CMAKE_CURRENT_SOURCE_DIR}/gcc/${package}.cmake)
    else()
        include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    endif()
    set(SOURCE_LOCATION "")
endforeach()
list(LENGTH ep ep_length)
message(STATUS "Parsing ${ep_length} toolchain packages")
