ExternalProject_Add(expat
    URL "http://download.sourceforge.net/expat/expat-2.2.5.tar.bz2"
    URL_HASH SHA256=d9dc32efba7e74f788fcc4f212a43216fc37cf5f23f4c2339664d473353aedf6
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
