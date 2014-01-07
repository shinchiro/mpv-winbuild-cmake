ExternalProject_Add(libquvi_scripts
    DEPENDS luajit
    GIT_REPOSITORY "git://repo.or.cz/libquvi-scripts.git"
    GIT_TAG v0.4.18
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-nsfw
        --with-fixme
        --with-nlfy
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

autogen(libquvi_scripts)
