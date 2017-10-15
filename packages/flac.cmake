ExternalProject_Add(flac
    DEPENDS ogg
    GIT_REPOSITORY https://github.com/xiph/flac.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
        --disable-doxygen-docs
        --disable-xmms-plugin
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(flac)
extra_step(flac)
autogen(flac)
autoreconf(flac)
