ExternalProject_Add(libbluray
    DEPENDS
        libudfread
        freetype2
    GIT_REPOSITORY https://code.videolan.org/videolan/libbluray.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} autoreconf -fi && CONF=1 <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-examples
        --disable-doxygen-doc
        --disable-bdjava-jar
        --without-libxml2
        --without-fontconfig
        CFLAGS='-Ddec_init=libbluray_dec_init'
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libbluray)
cleanup(libbluray install)
