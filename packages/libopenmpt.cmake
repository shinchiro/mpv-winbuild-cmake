ExternalProject_Add(libopenmpt
    DEPENDS
        zlib
        ogg
        vorbis
        libsdl2
    URL https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.2+release.autotools.tar.gz
    URL_HASH SHA256=50c0d62ff2d9afefa36cce9f29042cb1fb8d4f0b386b81a0fc7734f35e21e6b6
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-openmpt123
        --disable-examples
        --disable-tests
        --disable-doxygen-doc
        --disable-doxygen-html
        --without-mpg123
        --without-flac
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(libopenmpt)
autoreconf(libopenmpt)
cleanup(libopenmpt install)
