ExternalProject_Add(opus
    DEPENDS gcc
    URL "http://downloads.xiph.org/releases/opus/opus-1.1.1.tar.gz"
    URL_HASH SHA256=9b84ff56bd7720d5554103c557664efac2b8b18acc4bbcc234cb881ab9a3371e
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(opus)
force_rebuild(opus)
