ExternalProject_Add(libsodium
    URL https://github.com/jedisct1/libsodium/archive/1.0.18.tar.gz
    URL_HASH SHA256=d59323c6b712a1519a5daf710b68f5e7fde57040845ffec53850911f10a5d4f4
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE} CFLAGS='-D_FORTIFY_SOURCE=0'
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autogen(libsodium)
extra_step(libsodium)
