ExternalProject_Add(gmp
    URL https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.xz
    URL_HASH SHA256=258e6cd51b3fbdfc185c716d55f82c08aff57df0c6fbd143cf6ed561267a1526
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

extra_step(gmp)
