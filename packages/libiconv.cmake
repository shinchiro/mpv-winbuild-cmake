if(CYGWIN OR MSYS)
    set(build --build=${TARGET_ARCH})
endif()

ExternalProject_Add(libiconv
    URL "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz"
    URL_HASH SHA256=ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        ${build}
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-nls
        --disable-shared
        --enable-extra-encodings
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(libiconv)
