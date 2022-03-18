ExternalProject_Add(expat
    URL https://github.com/libexpat/libexpat/releases/download/R_2_4_7/expat-2.4.7.tar.xz
    URL_HASH SHA256=9875621085300591f1e64c18fd3da3a0eeca4a74f884b9abac2758ad1bd07a7d
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
cleanup(expat install)
