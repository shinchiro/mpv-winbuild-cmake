ExternalProject_Add(ogg
    URL "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
    URL_HASH SHA256=e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692
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
