ExternalProject_Add(expat
    URL https://github.com/libexpat/libexpat/releases/download/R_2_4_8/expat-2.4.8.tar.xz
    URL_HASH SHA256=f79b8f904b749e3e0d20afeadecf8249c55b2e32d4ebb089ae378df479dcaf25
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
cleanup(expat install)
