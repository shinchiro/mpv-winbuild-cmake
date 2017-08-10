ExternalProject_Add(expat
    URL "http://download.sourceforge.net/expat/expat-2.2.3.tar.bz2"
    URL_HASH SHA256=b31890fb02f85c002a67491923f89bda5028a880fd6c374f707193ad81aace5f
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(expat)
force_rebuild(expat)
