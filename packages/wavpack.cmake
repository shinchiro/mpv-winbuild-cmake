ExternalProject_Add(wavpack
    DEPENDS gcc
    URL "http://www.wavpack.com/wavpack-4.70.0.tar.bz2"
    URL_HASH SHA256=2cade379b0aba99fbc4e442ccc6dac6c609f6212e46516a083e24c8c364430a4
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
