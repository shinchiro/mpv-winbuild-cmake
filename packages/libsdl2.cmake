ExternalProject_Add(libsdl2
    URL https://www.libsdl.org/release/SDL2-2.0.22.tar.gz
    URL_HASH SHA256=fe7cbf3127882e3fc7259a75a0cb585620272c51745d3852ab9dd87960697f2e
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
