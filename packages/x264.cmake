ExternalProject_Add(x264
    DEPENDS gcc
    GIT_REPOSITORY "git://git.videolan.org/x264.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --enable-win32thread
        --disable-interlaced
        --disable-swscale
        --disable-lavf
        --disable-ffms
        --disable-gpac
        --disable-lsmash
        --bit-depth=8
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(x264)
