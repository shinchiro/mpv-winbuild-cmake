ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.26.4.tar.gz
    URL_HASH SHA256=1A0F686498FB768AD9F3F80B39037A7D006EAC093AAD39CB4EBCC832A8887231
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
