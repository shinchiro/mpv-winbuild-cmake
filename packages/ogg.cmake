ExternalProject_Add(ogg
    URL http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.xz
    URL_HASH SHA256=4f3fc6178a533d392064f14776b23c397ed4b9f48f5de297aba73b643f955c08
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(ogg)
autoreconf(ogg)
