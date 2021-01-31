ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.0.14.tar.gz
    URL_HASH SHA256=d8215b571a581be1332d2106f8036fcb03d12a70bae01e20f424976d275432bc
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
