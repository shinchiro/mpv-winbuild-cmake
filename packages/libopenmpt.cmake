ExternalProject_Add(libopenmpt
    DEPENDS
        zlib
        ogg
        vorbis
        libsdl2
    URL https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.4+release.autotools.tar.gz
    URL_HASH SHA256=1600F9335EAE3904089A6286F525812961C54CE36A05DFE6EEAA576DD9328F3F
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} autoreconf -fi && CONF=1 <SOURCE_DIR>/configure
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
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libopenmpt install)
