ExternalProject_Add(libsdl2
    URL http://libsdl.org/release/SDL2-2.0.12.tar.gz
    URL_HASH SHA256=349268f695c02efbc9b9148a70b85e58cefbbf704abd3e91be654db7f1e2c863
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autogen(libsdl2)
extra_step(libsdl2)
