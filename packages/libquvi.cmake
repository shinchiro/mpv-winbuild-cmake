ExternalProject_Add(libquvi
    DEPENDS lua libquvi_scripts libcurl
    GIT_REPOSITORY "git://github.com/lachs0r/libquvi.git"
    #GIT_REPOSITORY "git://repo.or.cz/libquvi.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-scriptsdir=libquvi-scripts
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libquvi)
autogen(libquvi)
