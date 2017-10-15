ExternalProject_Add(vorbis
    DEPENDS ogg
    URL "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz"
    URL_HASH SHA256=6efbcecdd3e5dfbf090341b485da9d176eb250d893e3eb378c428a2db38301ce
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(vorbis)
