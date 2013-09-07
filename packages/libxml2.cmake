ExternalProject_Add(libxml2
    DEPENDS gcc
    URL "ftp://xmlsoft.org/libxml2/libxml2-2.9.1.tar.gz"
    URL_MD5 9c0cfef285d5c4a5c80d00904ddab380
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --without-threads
        --without-python
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
