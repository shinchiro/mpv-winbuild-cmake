ExternalProject_Add(libjpeg
    DEPENDS gcc
    URL "http://download.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.4.2.tar.gz"
    URL_HASH SHA256=521bb5d3043e7ac063ce3026d9a59cc2ab2e9636c655a2515af5f4706122233e
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libjpeg)