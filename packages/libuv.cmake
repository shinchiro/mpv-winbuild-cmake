ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.39.0.tar.gz
    URL_HASH SHA256=dc7b21f1bb7ef19f4b42c5ea058afabe51132d165da18812b70fb319659ba629
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autogen(libuv)
extra_step(libuv)
