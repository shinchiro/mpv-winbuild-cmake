set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download patch configure build install)
include(${PROJECT_SOURCE_DIR}/cmake/toolchain_check.cmake)
list(APPEND ep
    llvm-wrapper
    mingw-w64
    mingw-w64-headers
    mingw-w64-winpthreads
    mingw-w64-crt
    mingw-w64-gendef
    cppwinrt
    rustup
    zlib-host
    libxml2-host
    zstd-host
    mimalloc-host
    llvm
    llvm-compiler-rt-builtin
    llvm-libcxx
    llvm-compiler-rt
    llvm-clang
)
foreach(package IN LISTS ep)
    if(NOT ${SINGLE_SOURCE_LOCATION} STREQUAL "")
        set(SOURCE_LOCATION "${SINGLE_SOURCE_LOCATION}/${package}")
    endif()
    if(package MATCHES "llvm")
        include(${CMAKE_CURRENT_SOURCE_DIR}/llvm/${package}.cmake)
    elseif(package MATCHES "mingw-w64")
        include(${CMAKE_CURRENT_SOURCE_DIR}/mingw-w64/${package}.cmake)
    else()
        include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    endif()
    set(SOURCE_LOCATION "")
    get_property(_git_repository TARGET ${package} PROPERTY _EP_GIT_REPOSITORY)
    if(_git_repository)
        list(APPEND repo ${package})
    endif()
endforeach()
list(LENGTH ep ep_length)
message(STATUS "Parsing ${ep_length} toolchain packages")
list(TRANSFORM repo APPEND "-force-update" OUTPUT_VARIABLE update)
list(TRANSFORM ep APPEND "-download" OUTPUT_VARIABLE download)
list(TRANSFORM ep APPEND "-fullclean" OUTPUT_VARIABLE fullclean)

add_custom_target(toolchain-update
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${update}
    COMMENT "Updating git repo"
)

add_custom_target(toolchain-download
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${download}
)

add_custom_target(toolchain-fullclean
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${fullclean}
    COMMENT "Remove all stamp files, reset git HEAD"
)
