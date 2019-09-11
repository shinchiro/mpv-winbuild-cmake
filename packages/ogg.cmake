ExternalProject_Add(ogg
    URL https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.4.tar.xz
    URL_HASH SHA256=c163bc12bc300c401b6aa35907ac682671ea376f13ae0969a220f7ddf71893fe
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
