ExternalProject_Add(winpthreads
    DEPENDS gcc
    SVN_REPOSITORY "http://svn.code.sf.net/p/mingw-w64/code/trunk/mingw-w64-libraries/winpthreads/"
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
