ExternalProject_Add(libquvi
    DEPENDS lua libquvi_scripts libcurl
    GIT_REPOSITORY "git://github.com/lachs0r/libquvi.git"
    #GIT_REPOSITORY "git://repo.or.cz/libquvi.git"
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-scriptsdir=libquvi-scripts
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libquvi autogen
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} ./autogen.sh
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
