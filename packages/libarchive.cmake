ExternalProject_Add(libarchive
    DEPENDS
        bzip2
        expat
        libressl
        lzo
        xz
        zlib
    URL "http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz"
    URL_HASH SHA256=eb87eacd8fe49e8d90c8fdc189813023ccc319c5e752b01fb6ad0cc7b2c53d5e
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-bsdtar
        --disable-bsdcat
        --disable-bsdcpio
        --without-xml2
        --without-nettle
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libarchive)
