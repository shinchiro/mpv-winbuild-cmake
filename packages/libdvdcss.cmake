ExternalProject_Add(libdvdcss
    GIT_REPOSITORY https://code.videolan.org/videolan/libdvdcss.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-doc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libdvdcss)
autoreconf(libdvdcss)
cleanup(libdvdcss install)
