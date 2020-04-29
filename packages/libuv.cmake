ExternalProject_Add(libuv
    URL https://github.com/libuv/libuv/archive/v1.37.0.tar.gz
    URL_HASH SHA256=7afa3c8a326b3eed02a9addb584ae7e995ae4d30516cad5e1e4af911931162a6
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autogen(libuv)
extra_step(libuv)
