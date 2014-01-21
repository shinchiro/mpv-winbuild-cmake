ExternalProject_Add(gnutls
    DEPENDS nettle gettext pcre zlib
    URL "http://srsfckn.biz/hosted/gnutls-3.2.8.1.tar.bz2" # how long until CMake finally adds xz support?
    URL_MD5 8a0fad3b754ad7ba6882e1dcb66ff963
    PATCH_COMMAND patch -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/gnutls-0001-Add-crypt32-to-pc-file.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-doc
        --disable-tests
        --disable-rpath
        --disable-nls
        --disable-guile
        --without-p11-kit
        --with-included-libtasn1
        --enable-threads=win32
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
