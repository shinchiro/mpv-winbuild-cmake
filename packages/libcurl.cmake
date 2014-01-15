ExternalProject_Add(libcurl
    DEPENDS gcc
    URL "http://curl.haxx.se/download/curl-7.34.0.tar.bz2"
    URL_MD5 88491df2bb32e9146e776ae6ac2f8327
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --without-libidn
        --without-gnutls
        --enable-sspi
        --enable-ipv6
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
