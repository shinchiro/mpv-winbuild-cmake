ExternalProject_Add(libbluray
    DEPENDS freetype2
    GIT_REPOSITORY http://git.videolan.org/git/libbluray.git
	GIT_TAG 6a86556953fe84694ba25db3306640a1191afc01
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
        --enable-udf
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
