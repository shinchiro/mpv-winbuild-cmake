ExternalProject_Add(lame
    GIT_REPOSITORY git://anonscm.debian.org/pkg-multimedia/lame.git
    UPDATE_COMMAND ""
    PATCH_COMMAND ${DEBPATCH}
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-frontend
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(lame)
extra_step(lame)
autoreconf(lame)
