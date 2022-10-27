ExternalProject_Add(expat
    URL https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-2.5.0.tar.xz
    URL_HASH SHA256=ef2420f0232c087801abf705e89ae65f6257df6b7931d37846a193ef2e8cdcbe
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(expat install)
