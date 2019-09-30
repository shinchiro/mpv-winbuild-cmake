ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.32.0.tar.gz
    URL_HASH SHA256=c9818f38eee79d4e56f3ae55320d207ab183c5d4aff0fb148b5d6f5702f371cd
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
