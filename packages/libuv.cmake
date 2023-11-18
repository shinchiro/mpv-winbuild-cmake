ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.40.0.tar.gz
    URL_HASH SHA256=70fe1c9ba4f2c509e8166c0ca2351000237da573bb6c82092339207a9715ba6b
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/autogen.sh && <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libuv install)
