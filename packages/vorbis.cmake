ExternalProject_Add(vorbis
    DEPENDS ogg
    URL "https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.xz"
    URL_HASH SHA256=af00bb5a784e7c9e69f56823de4637c350643deedaf333d0fa86ecdba6fcb415
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
