configure_file(${CMAKE_CURRENT_SOURCE_DIR}/mimalloc_override.c ${CMAKE_CURRENT_BINARY_DIR}/mimalloc_override.c @ONLY)
ExternalProject_Add(mimalloc
    GIT_REPOSITORY https://github.com/microsoft/mimalloc.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DMI_OVERRIDE=ON
        -DMI_BUILD_SHARED=OFF
        -DMI_BUILD_TESTS=OFF
        -DMI_WIN_REDIRECT=OFF
        -DMI_USE_CXX=ON
        -DMI_INSTALL_TOPLEVEL=ON
        -DMI_SKIP_COLLECT_ON_EXIT=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
            COMMAND ${EXEC} ${TARGET_ARCH}-gcc -c ${CMAKE_CURRENT_BINARY_DIR}/mimalloc_override.c -o mimalloc_override.o
            COMMAND ${EXEC} cp <BINARY_DIR>/mimalloc_override.o ${MINGW_INSTALL_PREFIX}/lib/mimalloc_override.o
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mimalloc)
cleanup(mimalloc install)
