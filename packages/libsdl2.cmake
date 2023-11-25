ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.28.4.tar.gz
    URL_HASH SHA256=888B8C39F36AE2035D023D1B14AB0191EB1D26403C3CF4D4D5EDE30E66A4942C
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/autogen.sh && <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libsdl2 install)
