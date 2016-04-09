ExternalProject_Add(zlib
    URL "http://zlib.net/zlib-1.2.8.tar.gz"
    URL_MD5 44d667c142d7cda120332623eab69f40
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/zlib-1-win32-static.patch
    CONFIGURE_COMMAND ${EXEC} CHOST=${TARGET_ARCH} <SOURCE_DIR>/configure
        --prefix=${MINGW_INSTALL_PREFIX}
        --static
    BUILD_COMMAND ${MAKE}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild(zlib)
