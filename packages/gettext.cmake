ExternalProject_Add(gettext
    DEPENDS libiconv
    URL "http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.3.1.tar.gz"
    URL_MD5 3fc808f7d25487fc72b5759df7419e02
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --without-expat-prefix
        --without-libxml2-prefix
        --enable-threads=windows
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
