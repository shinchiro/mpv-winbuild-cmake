ExternalProject_Add(libjpeg
    URL "http://download.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz"
    URL_HASH SHA256=9f397c31a67d2b00ee37597da25898b03eb282ccd87b135a50a69993b6a2035f
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libjpeg)