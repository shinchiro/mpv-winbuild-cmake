ExternalProject_Add(lame
    DEPENDS gcc
    URL "http://download.sourceforge.net/lame/lame-3.99.5.tar.gz"
    URL_MD5 84835b313d4a8b68f5349816d33e07ce
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-frontend
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
