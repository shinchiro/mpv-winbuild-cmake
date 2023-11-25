ExternalProject_Add(termcap
    URL https://ftp.gnu.org/gnu/termcap/termcap-1.3.1.tar.gz
    URL_HASH SHA256=91a0e22e5387ca4467b5bcb18edf1c51b930262fd466d5fda396dd9d26719100
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        CC=${TARGET_ARCH}-gcc
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
    INSTALL_COMMAND ${MAKE}
        RANLIB=${TARGET_ARCH}-ranlib
        install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(termcap install)
