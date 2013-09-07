ExternalProject_Add(libcurl
    DEPENDS gcc
    URL "http://curl.haxx.se/download/curl-7.32.0.tar.bz2"
    URL_MD5 30d04b0a8c43c6770039d1bf033dfe79
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/curl-1-fix-static.patch
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
