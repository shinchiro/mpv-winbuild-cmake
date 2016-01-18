ExternalProject_Add(gmp
    DEPENDS gcc
    URL "https://gmplib.org/download/gmp/gmp-6.1.0.tar.bz2"
    URL_HASH SHA256=498449a994efeba527885c10405993427995d3f86b8768d8cdf8d9dd7c6b73e8
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild(gmp)
