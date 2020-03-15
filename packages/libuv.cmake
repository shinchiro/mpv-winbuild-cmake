ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.35.0.tar.gz
    URL_HASH SHA256=ff84a26c79559e511f087aa67925c3b4e0f0aac60cd8039d4d38b292f208ff58
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
