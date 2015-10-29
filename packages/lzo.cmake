ExternalProject_Add(lzo
    DEPENDS gcc
    URL "http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz"
    URL_HASH SHA1=e2a60aca818836181e7e6f8c4f2c323aca6ac057
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(lzo)
force_rebuild(lzo)
