ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.23.0.tar.gz
    URL_HASH SHA256=8c8eff0bec85306aae508392b395e8bb0e1e34daad2a4e3bec308ced0c92bfaa
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
