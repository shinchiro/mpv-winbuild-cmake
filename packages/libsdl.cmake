ExternalProject_Add(libsdl
    DEPENDS gcc
    URL "http://www.libsdl.org/release/SDL-1.2.15.tar.gz"
    URL_MD5 9d96df8417572a2afb781a7c4c811a85
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
