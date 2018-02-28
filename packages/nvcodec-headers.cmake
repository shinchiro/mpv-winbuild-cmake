ExternalProject_Add(nvcodec-headers
    GIT_REPOSITORY https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${MAKE}
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(nvcodec-headers)
extra_step(nvcodec-headers)
