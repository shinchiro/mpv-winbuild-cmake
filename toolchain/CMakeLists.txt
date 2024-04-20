set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
include(${PROJECT_SOURCE_DIR}/cmake/toolchain_check.cmake)
list(APPEND ep
    gcc-binutils
    ${llvm_wrapper}
    ${gcc_wrapper}
    mingw-w64
    mingw-w64-headers
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
function(tc_delete_dir)
    foreach(arg IN LISTS ARGV)
        ExternalProject_Add_Step(${arg} tc_delete-dir
            DEPENDEES install
            COMMAND bash -c "find <BINARY_DIR> -mindepth 1 -delete && git -C <SOURCE_DIR> clean -df"
            COMMENT "Delete build directory"
        )
    endforeach()
endfunction()
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
