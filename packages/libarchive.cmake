ExternalProject_Add(libarchive
    DEPENDS
        bzip2
        expat
        lzo
        xz
        zlib
        nettle
    GIT_REPOSITORY https://github.com/libarchive/libarchive.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-bsdtar
        --disable-bsdcat
        --disable-bsdcpio
        --with-lzo2
        --without-xml2
        --without-cng
        --without-openssl
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libarchive)
autoreconf(libarchive)
cleanup(libarchive install)
