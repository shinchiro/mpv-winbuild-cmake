ExternalProject_Add(vorbis
    DEPENDS ogg
    URL "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz"
    URL_HASH SHA256=eee09a0a13ec38662ff949168fe897a25d2526529bc7e805305f381c219a1ecb
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
