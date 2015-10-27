ExternalProject_Add(opencore-amr
    DEPENDS gcc
    GIT_REPOSITORY git://git.code.sf.net/p/opencore-amr/code
    GIT_DEPTH 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/opencore-amr-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(opencore-amr)
force_rebuild_git(opencore-amr)
autoreconf(opencore-amr)
