ExternalProject_Add(libjpeg
    DEPENDS gcc
    URL "http://www.ijg.org/files/jpegsrc.v9a.tar.gz"
    URL_HASH SHA256=3a753ea48d917945dd54a2d97de388aa06ca2eb1066cbfdc6652036349fe05a7
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
