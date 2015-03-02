ExternalProject_Add(libjpeg
    DEPENDS gcc
    URL "http://download.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.4.0.tar.gz"
    URL_HASH SHA256=d93ad8546b510244f863b39b4c0da0fa4c0d53a77b61a8a3880f258c232bbbee
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
