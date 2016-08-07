ExternalProject_Add(opus-tools
    DEPENDS
        ogg
        opus
        flac
    GIT_REPOSITORY https://github.com/xiph/opus-tools.git
    GIT_DEPTH 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        LDFLAGS='-static'
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(opus-tools)
force_rebuild_git(opus-tools)
autogen(opus-tools)
