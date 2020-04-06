ExternalProject_Add(opus-tools
    DEPENDS
        ogg
        opus
        flac
        opusfile
        libopusenc
    GIT_REPOSITORY https://github.com/xiph/opus-tools.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-stack-protector
        CFLAGS='-D_FORTIFY_SOURCE=0'
        LDFLAGS='-static'
        FLAC_CFLAGS='-DFLAC__NO_DLL'
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(opus-tools)
extra_step(opus-tools)
autogen(opus-tools)
