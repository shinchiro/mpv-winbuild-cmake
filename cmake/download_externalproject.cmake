execute_process(
    COMMAND mkdir -p cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/modules.tar.gz")
    execute_process(
        COMMAND curl -sL https://gitlab.kitware.com/cmake/cmake/-/archive/release/cmake-release.tar.gz?path=Modules/ExternalProject -o modules.tar.gz
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    execute_process(
        COMMAND tar -C ${CMAKE_CURRENT_BINARY_DIR}/cmake --strip-components=1 -xf modules.tar.gz
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
endif()

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake")
    execute_process(
        COMMAND curl -sLO https://gitlab.kitware.com/cmake/cmake/-/raw/release/Modules/ExternalProject.cmake?inline=false
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules
    )
    execute_process(
        COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/packages/cmake-0001-ExternalProject-changes.patch
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake
    )
endif()

include(${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake)
