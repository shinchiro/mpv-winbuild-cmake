ExternalProject_Add(zlib
    URL https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
    URL_HASH SHA256=1525952a0a567581792613a9723333d7f8cc20b87a81f920fb8bc7e3f2251428
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
