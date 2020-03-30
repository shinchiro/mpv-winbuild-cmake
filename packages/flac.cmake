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
        --disable-thorough-tests
        --disable-oggtest
        --disable-examples
    BUILD_COMMAND ${MAKE} CFLAGS='-D_FORTIFY_SOURCE=0'
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(flac)
extra_step(flac)
autogen(flac)
