ExternalProject_Add(libopenmpt
    DEPENDS
        zlib
        ogg
        vorbis
        libsdl2
    URL https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.8+release.autotools.tar.gz
    URL_HASH SHA256=87778C8046A226C6CBFB114F4C8E3E27C121B7B3DCCCE5CB7DE45899250274CC
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
