ExternalProject_Add(fribidi
    DEPENDS gcc
    GIT_REPOSITORY git://anongit.freedesktop.org/fribidi/fribidi
    GIT_DEPTH 1
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

clean_build_dir(fribidi)
force_rebuild(fribidi)
