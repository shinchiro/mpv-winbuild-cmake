ExternalProject_Add(libssh
    DEPENDS
        zlib
        libressl
    GIT_REPOSITORY https://git.libssh.org/projects/libssh.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/libssh-*.patch
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DWITH_ZLIB=ON
        -DBUILD_STATIC_LIB=ON
        -DWITH_EXAMPLES=OFF
        -DBUILD_SHARED_LIBS=OFF
        # These functions will be declared in libcrypto. Assume they're exist to avoid linking problem later.
        -DHAVE_STRNDUP=ON
        -DHAVE_EXPLICIT_BZERO=ON
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libssh)
extra_step(libssh)
