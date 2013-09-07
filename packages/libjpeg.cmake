ExternalProject_Add(libjpeg
    DEPENDS gcc
    URL "http://www.ijg.org/files/jpegsrc.v9.tar.gz"
    URL_MD5 b397211ddfd506b92cd5e02a22ac924d
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
