ExternalProject_Add(lame
    DEPENDS gcc
	DOWNLOAD_COMMAND git clone git://anonscm.debian.org/pkg-multimedia/lame.git --depth 1
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
autoreconf(lame)
