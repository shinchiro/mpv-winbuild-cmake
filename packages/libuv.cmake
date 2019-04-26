ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.28.0.tar.gz
    URL_HASH SHA256=9ab338062e5b73bd4a05b7fcb77a0745c925c0be9118e0946434946a262cdad5
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
