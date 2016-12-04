ExternalProject_Add(libjpeg
    URL "http://download.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz"
    URL_HASH SHA256=41429d3d253017433f66e3d472b8c7d998491d2f41caa7306b8d9a6f2a2c666c
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libjpeg)