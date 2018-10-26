ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.23.2.tar.gz
    URL_HASH SHA256=30af979c4f4b8d1b895ae6d115f7400c751542ccb9e656350fc89fda08d4eabd
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
