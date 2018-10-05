ExternalProject_Add(expat
    URL "https://download.sourceforge.net/expat/expat-2.2.6.tar.bz2"
    URL_HASH SHA256=17b43c2716d521369f82fc2dc70f359860e90fa440bea65b3b85f0b246ea81f2
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
