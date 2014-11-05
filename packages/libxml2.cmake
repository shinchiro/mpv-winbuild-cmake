ExternalProject_Add(libxml2
    DEPENDS gcc
    URL "ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz"
    URL_HASH SHA256=5178c30b151d044aefb1b08bf54c3003a0ac55c59c866763997529d60770d5bc
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --without-threads
        --without-python
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
