ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.24.1.tar.gz
    URL_HASH SHA256=bc121588b1105065598ce38078026a414c28ea95e66ed2adab4c44d80b309e1b
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autogen(libsdl2)
cleanup(libsdl2 install)
