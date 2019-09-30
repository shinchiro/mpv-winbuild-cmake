ExternalProject_Add(expat
    URL "https://download.sourceforge.net/expat/expat-2.2.9.tar.bz2"
    URL_HASH SHA256=f1063084dc4302a427dabcca499c8312b3a32a29b7d2506653ecc8f950a9a237
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
