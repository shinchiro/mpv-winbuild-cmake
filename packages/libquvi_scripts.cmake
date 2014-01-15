ExternalProject_Add(libquvi_scripts
    DEPENDS luajit
    GIT_REPOSITORY "git://repo.or.cz/libquvi-scripts.git"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/libquvi_scripts-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-nsfw
        --with-fixme
        --without-manual
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

force_rebuild_git(libquvi_scripts)
autoreconf(libquvi_scripts)
