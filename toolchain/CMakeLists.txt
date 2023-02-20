set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
list(APPEND ep
    binutils
    mingw-w64
    mingw-w64-headers
    gcc
    mingw-w64-crt
    winpthreads
    gendef
    widl
    rustup
)
foreach(package IN LISTS ep)
    if(NOT ${SINGLE_SOURCE_LOCATION} STREQUAL "")
        set(SOURCE_LOCATION "${SINGLE_SOURCE_LOCATION}/${package}")
    endif()
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    set(SOURCE_LOCATION "")
endforeach()
list(LENGTH ep ep_length)
message(STATUS "Parsing ${ep_length} toolchain packages")
