ExternalProject_Add(libarchive
    DEPENDS
        bzip2
        expat
        lzo
        xz
        zlib
    URL "http://www.libarchive.org/downloads/libarchive-3.2.1.tar.gz"
    URL_HASH SHA256=72ee1a4e3fd534525f13a0ba1aa7b05b203d186e0c6072a8a4738649d0b3cfd2
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
        --without-openssl
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libarchive)
force_rebuild(libarchive)
