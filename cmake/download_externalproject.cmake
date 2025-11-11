set(version "v3.31.6")

execute_process(
    COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject
)

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/setup_done")
    execute_process(
        COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject
        # Download github folder via https://download-directory.github.io/?url=https://github.com/Kitware/CMake/tree/v3.31.6/Modules/ExternalProject
        COMMAND unzip ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CMake-${version}-Modules-ExternalProject.zip -d ${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject
        COMMAND curl -sLO https://github.com/Kitware/CMake/raw/refs/tags/${version}/Modules/ExternalProject.cmake
        COMMAND touch setup_done
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules
    )
    execute_process(
        COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/packages/cmake-0001-ExternalProject-changes.patch
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake
    )
endif()

include(${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake)
