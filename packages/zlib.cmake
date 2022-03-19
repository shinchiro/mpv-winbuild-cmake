ExternalProject_Add(zlib
    URL https://github.com/madler/zlib/archive/refs/tags/v1.2.12.tar.gz
    URL_HASH SHA256=d8688496ea40fb61787500e863cc63c9afcbc524468cedeb478068924eb54932
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/zlib-1-win32-static.patch
    CONFIGURE_COMMAND ${EXEC} CHOST=${TARGET_ARCH} <SOURCE_DIR>/configure
        --prefix=${MINGW_INSTALL_PREFIX}
        --static
    BUILD_COMMAND ${MAKE}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(zlib install)
