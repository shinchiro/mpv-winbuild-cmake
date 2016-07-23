ExternalProject_Add(libmodplug
    URL "http://download.sourceforge.net/modplug-xmms/libmodplug-0.8.8.5.tar.gz"
    URL_HASH SHA256=77462d12ee99476c8645cb5511363e3906b88b33a6b54362b4dbc0f39aa2daad
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libmodplug)
force_rebuild(libmodplug)
