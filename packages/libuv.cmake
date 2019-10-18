ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.33.0.tar.gz
    URL_HASH SHA256=d085b46aea791fb7772c274ccc58faadc56fdf6252d3b09b7fb24bd03881efdb
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
