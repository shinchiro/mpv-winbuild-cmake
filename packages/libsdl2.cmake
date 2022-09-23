ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.24.0.tar.gz
    URL_HASH SHA256=91e4c34b1768f92d399b078e171448c6af18cafda743987ed2064a28954d6d97
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/libsdl2-0001-mingw-header.patch
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
cleanup(libsdl2 install)
