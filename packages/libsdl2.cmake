ExternalProject_Add(libsdl2
    URL http://libsdl.org/release/SDL2-2.0.10.tar.gz
    URL_HASH SHA256=b4656c13a1f0d0023ae2f4a9cf08ec92fffb464e0f24238337784159b8b91d57
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
