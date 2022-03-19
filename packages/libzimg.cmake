ExternalProject_Add(libzimg
    GIT_REPOSITORY https://github.com/sekrit-twc/zimg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libzimg)
autogen(libzimg)
cleanup(libzimg install)
