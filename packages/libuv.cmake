ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.20.2.tar.gz
    URL_HASH SHA256=a5e62a6ed3c25a712477b55ce923e7f49af95b80319f88b9c950200d65427793
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
