ExternalProject_Add(gmp
    URL https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz
    URL_HASH SHA256=64b1102fa22093515b02ef33dd8739dee1ba57e9dbba6a092942b8bbed1a1c5e
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        CC_FOR_BUILD=cc
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(gmp install)
