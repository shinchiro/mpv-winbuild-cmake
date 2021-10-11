ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.0.16.tar.gz
    URL_HASH SHA256=65be9ff6004034b5b2ce9927b5a4db1814930f169c4b2dae0a1e4697075f287b
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
cleanup(libsdl2 install)
