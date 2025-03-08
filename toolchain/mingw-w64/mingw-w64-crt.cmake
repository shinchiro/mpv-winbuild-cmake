ExternalProject_Add(mingw-w64-crt
    DEPENDS
        mingw-w64
        mingw-w64-headers
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${MINGW_SRC}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/mingw-w64-crt/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --with-default-msvcrt=ucrt
        --enable-wildcard
        --enable-cfguard
        ${crt_lib}
    BUILD_COMMAND ${MAKE} LTO=0 GC=0
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(mingw-w64-crt install)
