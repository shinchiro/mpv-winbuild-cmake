ExternalProject_Add(expat
    URL "http://download.sourceforge.net/expat/expat-2.2.0.tar.bz2"
    URL_HASH SHA256=d9e50ff2d19b3538bd2127902a89987474e1a4db8e43a66a4d1a712ab9a504ff
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
