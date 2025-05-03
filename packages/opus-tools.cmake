ExternalProject_Add(opus-tools
    DEPENDS
        ogg
        opus
        flac
        opusfile
        libopusenc
    GIT_REPOSITORY https://github.com/xiph/opus-tools.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/autogen.sh && CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
        --disable-stack-protector
        CFLAGS='-D_FORTIFY_SOURCE=0'
        LDFLAGS='-static'
        FLAC_CFLAGS='-DFLAC__NO_DLL'
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(opus-tools)
cleanup(opus-tools install)
