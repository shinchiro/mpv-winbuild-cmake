ExternalProject_Add(expat
    DEPENDS gcc
    URL "http://download.sourceforge.net/expat/expat-2.1.0.tar.gz"
    URL_MD5 dd7dab7a5fea97d2a6a43f511449b7cd
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(expat)
force_rebuild(expat)
