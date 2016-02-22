ExternalProject_Add(libbluray
    DEPENDS freetype2
    GIT_REPOSITORY git://git.videolan.org/libbluray.git
    GIT_TAG 6f16e18bd09284db04a79d3bd001bb2c06c013fd
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-examples
        --disable-doxygen-doc
        --disable-bdjava
        --without-libxml2
        --without-fontconfig
        --disable-udf
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libbluray)

ExternalProject_Add_Step(libbluray bootstrap
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} ./bootstrap
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
