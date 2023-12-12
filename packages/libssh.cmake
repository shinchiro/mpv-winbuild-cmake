configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libssh.pc.in ${CMAKE_CURRENT_BINARY_DIR}/libssh.pc @ONLY)
ExternalProject_Add(libssh
    DEPENDS
        zlib
        openssl
    GIT_REPOSITORY https://git.libssh.org/projects/libssh.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DWITH_ZLIB=ON
        -DBUILD_STATIC_LIB=ON
        -DWITH_EXAMPLES=OFF
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -DHAVE_COMPILER__FUNC__=1'
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
            COMMAND bash -c "cp ${CMAKE_CURRENT_BINARY_DIR}/libssh.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/libssh.pc"
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libssh)
cleanup(libssh install)
