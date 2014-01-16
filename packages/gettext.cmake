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

ExternalProject_Get_Property(libiconv CONFIGURE_COMMAND BUILD_COMMAND INSTALL_COMMAND)
ExternalProject_Add_Step(gettext rebuild-iconv
    DEPENDEES install
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/libiconv-prefix/src/libiconv-build
    COMMAND ${CONFIGURE_COMMAND}
    COMMAND ${BUILD_COMMAND}
    COMMAND ${INSTALL_COMMAND}
    LOG 1
)
