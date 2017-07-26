ExternalProject_Add(libjpeg
    URL "http://download.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.2.tar.gz"
    URL_HASH SHA256=9098943b270388727ae61de82adec73cf9f0dbb240b3bc8b172595ebf405b528
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libjpeg)
