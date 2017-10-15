ExternalProject_Add(lzo
    URL "https://fossies.org/linux/misc/lzo-2.10.tar.gz"
    URL_HASH SHA1=4924676a9bae5db58ef129dc1cebce3baa3c4b5d
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(lzo)
