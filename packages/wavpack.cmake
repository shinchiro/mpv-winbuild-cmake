ExternalProject_Add(wavpack
    DEPENDS gcc
    URL "http://www.wavpack.com/wavpack-4.60.1.tar.bz2"
    URL_MD5 7bb1528f910e4d0003426c02db856063
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --without-iconv
        CFLAGS=-DWIN32
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
