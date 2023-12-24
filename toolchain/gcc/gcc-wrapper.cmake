ExternalProject_Add(gcc-wrapper
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND bash -c "rm -r <TMP_DIR>"
    ALWAYS ON
)

foreach(compiler g++ c++ cpp gcc)
    if(EXISTS ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler})
        file(SIZE ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler} GCC_SIZE)
        if(GCC_SIZE GREATER "10000")
            file(RENAME ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler} ${CMAKE_INSTALL_PREFIX}/bin/cross-${compiler})
        endif()
        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gcc/gcc-compiler.in
                       ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler}
                       FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                       @ONLY)
    endif()
endforeach()

foreach(linker ld ld.bfd)
    if(EXISTS ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${linker})
        file(SIZE ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${linker} BFD_SIZE)
        if(BFD_SIZE GREATER "10000")
            file(RENAME ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${linker} ${CMAKE_INSTALL_PREFIX}/bin/cross-${linker})
        endif()
        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gcc/gcc-ld.in
                       ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${linker}
                       FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                       @ONLY)
    endif()
endforeach()

cleanup(gcc-wrapper install)
