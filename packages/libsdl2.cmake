ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.28.2.tar.gz
    URL_HASH SHA256=64b1102fa22093515b02ef33dd8739dee1ba57e9dbba6a092942b8bbed1a1c5e
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
