ExternalProject_Add(mingw-w64-gendef
    DEPENDS
        mingw-w64
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${MINGW_SRC}
    CONFIGURE_COMMAND ${EXEC} CONF=1 PATH=$O_PATH <SOURCE_DIR>/mingw-w64-tools/gendef/configure
        --prefix=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(mingw-w64-gendef install)
tc_delete_dir(mingw-w64-gendef)
