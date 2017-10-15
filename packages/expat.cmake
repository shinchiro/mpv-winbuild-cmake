ExternalProject_Add(expat
    URL "http://download.sourceforge.net/expat/expat-2.2.4.tar.bz2"
    URL_HASH SHA256=03ad85db965f8ab2d27328abcf0bc5571af6ec0a414874b2066ee3fdd372019e
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
