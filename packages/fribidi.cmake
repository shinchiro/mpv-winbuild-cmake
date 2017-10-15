ExternalProject_Add(fribidi
    URL "http://fribidi.org/download/fribidi-0.19.7.tar.bz2"
    URL_HASH SHA256=08222a6212bbc2276a2d55c3bf370109ae4a35b689acbc66571ad2a670595a8e
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-deprecated
        --without-glib
        --enable-charsets
        --enable-malloc
    BUILD_COMMAND ${MAKE} -j1 # breaks with parallel make
    INSTALL_COMMAND ${MAKE} -j1 install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(fribidi)
autoreconf(fribidi)
