ExternalProject_Add(libbluray
    DEPENDS libxml2 freetype2
    GIT_REPOSITORY "git://git.videolan.org/libbluray.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-examples
        --disable-doxygen-doc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libbluray force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(libbluray bootstrap
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} ./bootstrap
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
