ExternalProject_Add(zlib
    URL "http://download.sourceforge.net/libpng/zlib-1.2.11.tar.gz"
    URL_HASH SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/zlib-1-win32-static.patch
    CONFIGURE_COMMAND ${EXEC} CHOST=${TARGET_ARCH} <SOURCE_DIR>/configure
        --prefix=${MINGW_INSTALL_PREFIX}
        --static
    BUILD_COMMAND ${MAKE}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(zlib)
