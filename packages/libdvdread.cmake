ExternalProject_Add(libdvdread
    DEPENDS libdvdcss
    DOWNLOAD_COMMAND git clone git://git.videolan.org/libdvdread.git --depth 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-libdvdcss
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libdvdread)
autoreconf(libdvdread)
