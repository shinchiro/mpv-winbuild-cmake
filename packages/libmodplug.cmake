ExternalProject_Add(libmodplug
    URL "http://download.sourceforge.net/modplug-xmms/libmodplug-0.8.9.0.tar.gz"
    URL_HASH SHA256=457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(libmodplug)
